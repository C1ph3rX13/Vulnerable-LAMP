I=#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 脚本配置
set -e # 遇到错误立即退出

# --- 函数定义 ---

# 检查 Docker 是否安装和运行
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}[错误]${NC} Docker 命令未找到。请先安装 Docker。"
        exit 1
    fi

    if ! docker info &> /dev/null; then
        echo -e "${RED}[错误]${NC} Docker 守护进程未运行。请启动 Docker。"
        exit 1
    fi
    echo -e "${GREEN}[信息]${NC} Docker 环境检查通过。"
}

# 显示主菜单
show_menu() {
    clear
    echo -e "${BLUE}====================================================${NC}"
    echo -e "${BLUE}           Docker 资源清理工具${NC}"
    echo -e "${BLUE}====================================================${NC}"
    echo "请选择您要执行的清理操作:"
    echo "  1) 智能清理 (推荐)"
    echo "  2) 用户选择清理"
    echo "  3) 全部清理 (危险!)"
    echo "  4) 清理构建器 (Buildx) 缓存"
    echo "  5) 退出"
    echo -e "${BLUE}----------------------------------------------------${NC}"
}

# 智能清理
smart_clean() {
    echo -e "${YELLOW}[信息]${NC} 正在执行智能清理..."
    echo -e "  - 删除已停止的容器"
    echo -e "  - 删除未被使用的网络"
    echo -e "  - 删除悬空镜像"
    echo -e "  - 删除悬空的构建缓存"
    echo "----------------------------------------------------"
    
    # -f 参数表示 force，不进行交互式确认
    docker system prune -f
    
    echo -e "${GREEN}[成功]${NC} 智能清理完成。"
    read -p "按 Enter 键返回主菜单..."
}

# 用户选择清理
interactive_clean() {
    echo -e "${YELLOW}[信息]${NC} 进入用户选择清理模式，将逐一询问。"
    echo "----------------------------------------------------"

    # 1. 清理已停止的容器
    echo -e "\n${BLUE}--- 检查已停止的容器 ---${NC}"
    stopped_containers=$(docker ps -aq --filter "status=exited")
    if [ -n "$stopped_containers" ]; then
        docker ps -a --filter "status=exited"
        read -p "是否删除这些已停止的容器? [y/N]: " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            docker rm $stopped_containers
            echo -e "${GREEN}[成功]${NC} 已停止的容器已删除。"
        fi
    else
        echo -e "${GREEN}[信息]${NC} 没有发现已停止的容器。"
    fi

    # 2. 清理未使用的网络
    echo -e "\n${BLUE}--- 检查未使用的网络 ---${NC}"
    read -p "是否删除所有未被使用的网络? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker network prune -f
        echo -e "${GREEN}[成功]${NC} 未使用的网络已删除。"
    fi

    # 3. 清理悬空镜像
    echo -e "\n${BLUE}--- 检查悬空镜像 ---${NC}"
    dangling_images=$(docker images -f "dangling=true" -q)
    if [ -n "$dangling_images" ]; then
        docker images -f "dangling=true"
        read -p "是否删除这些悬空镜像? [y/N]: " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            docker rmi $dangling_images
            echo -e "${GREEN}[成功]${NC} 悬空镜像已删除。"
        fi
    else
        echo -e "${GREEN}[信息]${NC} 没有发现悬空镜像。"
    fi

    # 4. 清理所有未被使用的镜像
    echo -e "\n${BLUE}--- 检查所有未被使用的镜像 ---${NC}"
    read -p "是否删除所有未被任何容器使用的镜像? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker image prune -a -f
        echo -e "${GREEN}[成功]${NC} 未被使用的镜像已删除。"
    fi
    
    # 5. 清理未被使用的卷
    echo -e "\n${RED}--- 检查未被使用的卷 (数据将永久丢失!) ---${NC}"
    read -p "是否删除所有未被使用的卷? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker volume prune -f
        echo -e "${GREEN}[成功]${NC} 未被使用的卷已删除。"
    fi

    # 6. 清理构建缓存
    echo -e "\n${BLUE}--- 检查构建器缓存 ---${NC}"
    read -p "是否清理悬空的构建缓存? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker builder prune -f
        echo -e "${GREEN}[成功]${NC} 悬空的构建缓存已清理。"
    fi

    read -p "是否清理所有构建缓存 (更彻底)? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker builder prune -a -f
        echo -e "${GREEN}[成功]${NC} 所有构建缓存已清理。"
    fi

    echo -e "\n${GREEN}[成功]${NC} 用户选择清理完成。"
    read -p "按 Enter 键返回主菜单..."
}

# 全部清理
full_clean() {
    echo -e "${RED}[警告]${NC} 您选择了全部清理模式！"
    echo -e "${RED}这将删除：${NC}"
    echo -e "  - 所有已停止的容器"
    echo -e "  - 所有未被使用的网络"
    echo -e "  - ${RED}所有未被使用的镜像 (不仅仅是悬空镜像)${NC}"
    echo -e "  - ${RED}所有未被使用的卷 (数据将永久丢失!)${NC}"
    echo -e "  - 所有构建缓存"
    echo "----------------------------------------------------"
    
    # 二次确认
    read -p "此操作不可逆，确定要继续吗? 请输入 'YES' 来确认: " confirm
    if [ "$confirm" != "YES" ]; then
        echo -e "${YELLOW}[信息]${NC} 操作已取消。"
        read -p "按 Enter 键返回主菜单..."
        return
    fi

    echo -e "${YELLOW}[信息]${NC} 正在执行全部清理..."
    docker system prune -a --volumes -f
    
    echo -e "${GREEN}[成功]${NC} 全部清理完成。"
    read -p "按 Enter 键返回主菜单..."
}

# --- 核心：独立的构建器缓存清理函数 ---
clean_build_cache() {
    echo -e "${YELLOW}[信息]${NC} 进入构建器缓存清理模式。"
    echo "----------------------------------------------------"
    echo "请选择要清理的构建器缓存类型:"
    echo "  1) 清理悬空的构建缓存 (安全)"
    echo "     - 删除未被任何构建使用的旧缓存。"
    echo "  2) 清理所有构建缓存 (彻底)"
    echo "     - 删除所有缓存，包括当前构建可能正在使用的。"
    echo "  3) 返回主菜单"
    echo "----------------------------------------------------"
    read -p "请输入您的选择 [1-3]: " sub_choice

    case $sub_choice in
        1)
            echo -e "\n${BLUE}--- 正在清理悬空的构建缓存 ---${NC}"
            docker builder prune -f
            echo -e "${GREEN}[成功]${NC} 悬空的构建缓存已清理。"
            ;;
        2)
            echo -e "\n${BLUE}--- 正在清理所有构建缓存 ---${NC}"
            docker builder prune -a -f
            echo -e "${GREEN}[成功]${NC} 所有构建缓存已清理。"
            ;;
        3)
            return
            ;;
        *)
            echo -e "${RED}[错误]${NC} 无效的选项。"
            ;;
    esac
    read -p "按 Enter 键返回主菜单..."
}


# --- 主程序逻辑 ---

# 主循环
main_loop() {
    while true; do
        show_menu
        read -p "请输入您的选择 [1-5]: " choice
        case $choice in
            1)
                smart_clean
                ;;
            2)
                interactive_clean
                ;;
            3)
                full_clean
                ;;
            4)
                clean_build_cache
                ;;
            5)
                echo -e "${GREEN}[信息]${NC} 退出脚本。"
                exit 0
                ;;
            *)
                echo -e "${RED}[错误]${NC} 无效的选项，请输入 1 到 5 之间的数字。"
                read -p "按 Enter 键重新选择..."
                ;;
        esac
    done
}

# --- 脚本入口 ---
check_docker
main_loop

