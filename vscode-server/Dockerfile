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
    wget -q https://golang.google.cn/dl/go1.25.6.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.25.6.linux-amd64.tar.gz && \
    rm -f go1.25.6.linux-amd64.tar.gz && \
    # 清理缓存
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置环境变量 (Go)
ENV PATH="/usr/local/go/bin:/home/coder/go/bin:${PATH}"
ENV GOPROXY="https://goproxy.cn,direct"
ENV GOMODCACHE="/home/coder/go/pkg/mod"
ENV GOCACHE="/home/coder/go/cache"

# 设置环境变量 (Node.js)
# Node.js 的环境变量通常由系统安装自动配置

# 切换到 coder 用户并配置基础环境
USER coder
RUN mkdir -p /home/coder/go/pkg/mod /home/coder/go/cache && \
    # 在 coder 用户的 .bashrc 中添加环境变量，确保交互式 shell 中也能使用
    echo 'export PATH="/usr/local/go/bin:/home/coder/go/bin:$PATH"' >> /home/coder/.bashrc && \
    echo 'export GOPROXY="https://goproxy.cn,direct"' >> /home/coder/.bashrc && \
    echo 'export GOMODCACHE="/home/coder/go/pkg/mod"' >> /home/coder/.bashrc && \
    echo 'export GOCACHE="/home/coder/go/cache"' >> /home/coder/.bashrc

# 预装 Go 核心工具 (这些工具较大且更新频率较低)
RUN go install -v golang.org/x/tools/gopls@latest && \
    go install -v github.com/go-delve/delve/cmd/dlv@latest && \
    go install -v github.com/haya14busa/goplay/cmd/goplay@latest && \
    go install -v github.com/josharian/impl@latest && \
    go install -v github.com/cweill/gotests/gotests@latest

# 安装 VS Code 插件 (将插件安装放在最后，方便后续增删)
RUN code-server --install-extension golang.Go && \
    code-server --install-extension donjayamanne.githistory && \
    code-server --install-extension eamodio.gitlens && \
    code-server --install-extension ms-vscode.makefile-tools && \
    code-server --install-extension ms-ceintl.vscode-language-pack-zh-hans

# 默认启动命令（通常不需要改，code-server 镜像里已经定义了）
# CMD ["code-server"]