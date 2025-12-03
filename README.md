# Vulnerable LAMP

🐳 一个用于安全研究的快速部署漏洞容器环境，具有持久化数据存储功能。

[![Docker](https://img.shields.io/badge/Docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

## 📋 目录

- [项目简介](#项目简介)
- [关键特性](#关键特性)
- [支持的系统](#支持的系统)
- [支持的软件](#支持的软件)
- [快速开始](#快速开始)
- [使用说明](#使用说明)
- [Docker 逃逸实验](#docker-逃逸实验)
- [常见问题](#常见问题)
- [许可证](#许可证)

## 项目简介

Vulnerable LAMP 是一个专为安全研究人员设计的漏洞测试环境，它提供了一个完整的 LAMP（Linux, Apache, MySQL, PHP）堆栈，其中包含了一些常见的安全漏洞，可用于学习、测试和研究目的。

该环境基于 Docker 容器技术，可以快速部署和销毁，确保不会对主机系统造成影响。

## 关键特性

### 🐳 自包含的数据存储
- MySQL 数据直接存储在容器内部
- 支持持久化数据存储

### ⚡ 快速设置研究环境
- 预配置的环境，针对漏洞分析和测试进行了优化
- 包含多种常见的安全漏洞场景

### 🔧 多种实验环境

- 提供不同版本的 MySQL 和 PHP 环境
- 包含 Docker 逃逸实验场景

## 支持的系统

- Ubuntu 20.04
- Ubuntu 22.04
- Ubuntu 24.04

## 支持的软件

| 组件 | 版本 |
|------|------|
| Apache | 2.4 |
| MySQL | 5.x, 8.x |
| PHP | 5.6 |

## 快速开始

### 构建镜像

```bash
# 构建特定环境的镜像
docker build -f <Dockerfile路径> -t <镜像名称>:标签 .
```

### 运行容器

```bash
# 启动容器并映射端口
docker run -d -p 端口:端口 <镜像名称>:标签
```

### 示例

```bash
# 构建 PHP 5.6 + MySQL 5.7 环境
docker build -f PhpWebServer/5.6/Dockerfile -t lamp-env:php5.6 .

# 运行容器，映射 Web 服务和 SSH 端口
docker run -d -p 80:80 -p 22:22 -p 3306:3306 lamp-env:php5.6
```

## 使用说明

### 访问服务

构建并运行容器后，可以通过以下方式访问服务：

- **Web 服务**: `http://localhost:80`
- **SSH 服务**: `ssh root@localhost -p 22` (密码: p@ss1234)
- **MySQL 服务**: `mysql -h localhost -P 3306 -u root -p` (密码: root)

### 默认账户信息

| 服务 | 用户名 | 密码 |
|------|--------|------|
| SSH | root | p@ss1234 |
| MySQL | root | root |

## Docker 逃逸实验

项目中包含了三种常见的 Docker 逃逸实验场景：

### 1. Docker Socket 挂载逃逸
利用原理：容器内拥有对宿主 Docker 守护进程的完全控制权。
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

### 2. 特权模式逃逸
利用原理：`--privileged` 参数赋予了容器几乎与宿主机相同的权限。
```yaml
privileged: true
```

### 3. 根目录挂载逃逸
利用原理：错误地将宿主机的根目录 `/` 挂载到了容器内的某个目录。
```yaml
volumes:
  - /:/host_fs
```

使用 `docker-compose.yml` 文件一键启动实验环境：
```bash
cd Docker\ Escape
docker-compose up -d
```

## 常见问题

### MySQL 8.x 使用 mysql_native_password

如果遇到以下报错导致 MySQL 无法启动：
```
Plugin 'mysql_native_password' is not loaded
```

解决方法：
```sql
-- 查看插件状态
SHOW PLUGINS;

-- 确认 mysql_native_password 插件是否已经安装
INSTALL PLUGIN mysql_native_password SONAME 'auth.so';

-- 修改 my.cnf 或 my.ini 配置文件
[mysqld]
mysql_native_password=ON

-- 注意：不要添加下面配置，否则mysql会无法启动
# default_authentication_plugin=mysql_native_password

-- mysql 命令行查看用户使用的插件
select user,host,plugin from mysql.user;

-- 修改密码认证方式
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your password';
FLUSH PRIVILEGES; #刷新权限
```

## 清理工具

项目提供了 `clean.sh` 脚本用于清理 Docker 资源：

```bash
chmod +x clean.sh
./clean.sh
```

脚本功能：
- 智能清理（推荐）
- 用户选择清理
- 全部清理（危险！）
- 清理构建器缓存

## 许可证

本项目采用 MIT 许可证，详情请参见 [LICENSE](LICENSE) 文件。

---

<p align="center">
  Made with ❤️ for security researchers
</p>
