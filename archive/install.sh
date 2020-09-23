#!/bin/sh

# Step 0 脚本设置
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

# Step 1 环境判断
# Reference
# https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
# https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux (this is better)

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Machine Type: "${GREEN}${machine}${NORMAL}
# Step 2 组装配置
bashConfig=".bashrc.v"
cat ./common.bashrc > ${bashConfig}
#if [[ "${machine}"=="Linux" ]]; then       Why~~~必须要空格
if [[ "${machine}" == "Linux" ]]; then
    cat ./like.unix.bashrc >> ${bashConfig}
    cat ./linux.bashrc >> ${bashConfig}
elif [[ "${machine}" == "Mac" ]]; then
    cat ./like.unix.bashrc >> ${bashConfig}
    cat ./mac.bashrc >> ${bashConfig}
elif [[ "${machine}" == "Windows" ]]; then
    cat ./windows.bashrc >> ${bashConfig}
fi



