# 使用官方最新的 code-server 镜像作为基础
FROM codercom/code-server:latest

# 设置非交互式安装,避免安装过程中卡住
ENV DEBIAN_FRONTEND=noninteractive

# 切换到 root 用户执行安装
USER root

# 配置国内镜像源
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list || true && \
    sed -i 's@//.*security.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list || true && \
    # 配置 Debian 源(如果是 Debian 系统)
    (sed -i 's@deb.debian.org@mirrors.aliyun.com@g' /etc/apt/sources.list || true) && \
    (sed -i 's@security.debian.org@mirrors.aliyun.com@g' /etc/apt/sources.list || true)

# 安装 Go 和 Node.js (使用国内镜像源)
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates wget && \
    # 直接安装 Node.js 和 npm (跳过 nodesource,使用系统源更快)
    apt-get install -y nodejs npm && \
    # 配置 npm 使用淘宝镜像
    npm config set registry https://registry.npmmirror.com && \
    # 安装 Go (使用国内镜像)
    wget -q https://golang.google.cn/dl/go1.23.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz && \
    rm -f go1.23.4.linux-amd64.tar.gz && \
    # 清理缓存
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置环境变量 (Go)
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPROXY="https://goproxy.cn,direct"
ENV GOMODCACHE="/home/coder/go/pkg/mod"
ENV GOCACHE="/home/coder/go/cache"

# 设置环境变量 (Node.js)
# Node.js 的环境变量通常由系统安装自动配置

# 确保 /home/coder 目录权限
USER coder
RUN mkdir -p /home/coder/go/pkg/mod /home/coder/go/cache

# 默认启动命令（通常不需要改，code-server 镜像里已经定义了）
# CMD ["code-server"]