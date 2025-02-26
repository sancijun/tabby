#!/bin/bash

# 检查IntelliJ版本是否符合要求
required_intellij_version="2023.1"

# 检查idea.sh是否存在
if ! command -v idea.sh &>/dev/null; then
    echo "错误：未找到idea.sh，请确保IntelliJ已安装并添加到PATH中！"
    exit 1
fi

# 获取IntelliJ版本
intellij_version=$(idea.sh --version | grep -oE '20[0-9]{2}\.[0-9]+(\.[0-9]+)?' | head -1)
if [ -z "$intellij_version" ]; then
    echo "无法获取IntelliJ版本！"
    exit 1
fi

# 版本比较
if [ "$(printf '%s\n' "$required_intellij_version" "$intellij_version" | sort -V | head -n1)" != "$required_intellij_version" ]; then
    echo "需要IntelliJ ${required_intellij_version}+，当前版本：${intellij_version}"
    echo "请访问 https://www.jetbrains.com/idea/download/ 升级"
    exit 1
fi

# 检查Node.js版本
required_node=18
node_version=$(node --version 2>/dev/null | grep -oE '[0-9]+' | head -1)

if [ -z "$node_version" ]; then
    echo "Node.js未安装！"
    echo "请使用以下方法安装Node.js 18+："
    echo "官方文档：https://nodejs.org/en/download/package-manager"
    exit 1
elif [ "$node_version" -lt $required_node ]; then
    echo "需要Node.js ${required_node}+，当前版本：v${node_version}"
    echo "推荐使用nvm管理Node版本：https://github.com/nvm-sh/nvm"
    exit 1
fi

# 下载插件
plugin_url="https://gitlab.npt.seabank.io/lixiaolong/be-horizontal-ai/-/raw/master/plugins/bank-copilot-intallij.zip"
zip_file="/tmp/bank-copilot-intellij.zip"

echo "正在下载插件..."
if command -v curl &>/dev/null; then
    curl -L -o "$zip_file" "$plugin_url"
elif command -v wget &>/dev/null; then
    wget -O "$zip_file" "$plugin_url"
else
    echo "错误：需要curl或wget来下载文件"
    exit 1
fi

# 安装插件
if [ ! -f "$zip_file" ]; then
    echo "插件下载失败！"
    exit 1
fi

echo "正在安装插件..."
if ! idea.sh install-plugin "$zip_file"; then
    echo "插件安装失败！请尝试以下方法："
    echo "1. 手动下载：${plugin_url}"
    echo "2. 通过IDE菜单安装：File -> Settings -> Plugins -> ⚙️ -> Install Plugin from Disk"
    exit 1
fi

# 清理临时文件
rm -f "$zip_file"

echo "✅ 插件安装成功！请重启IntelliJ使更改生效"