# FAQ

MySQL 8.x 使用 mysql_native_password

报错 / 无法启动

```bash
Plugin 'mysql_native_password' is not loaded
```

 解决方法

```bash
# 查看插件状态
SHOW PLUGINS;

# 确认 mysql_native_password 插件是否已经安装
INSTALL PLUGIN mysql_native_password SONAME 'auth.so';

# 修改 my.cnf 或 my.ini 配置文件
[mysqld]
mysql_native_password=ON

# 不要添加下面配置，否则mysql会无法启动
default_authentication_plugin=mysql_native_password

# mysql 命令行查看用户使用的插件
select user,host,plugin from mysql.user;

# 修改密码认证方式
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your password';
FLUSH PRIVILEGES; #刷新权限
```