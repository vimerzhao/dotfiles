# Author    vimerzhao
# Date      2019-11-06 10:56
# Desc      把 oh-my-zsh 的 git 插件的别名配置转化成 Git Alias 格式
# Usage     

input="~/.oh-my-zsh/plugins/git/git.plugin.zsh"
output="git.alias.default.sh"
# 提取所有关于别名的配置，并暂存

grep -E "alias g[a-zA-Z]+=.*" ~/.oh-my-zsh/plugins/git/git.plugin.zsh > temp1.sh
# 去掉命令里面的 `git`，符合 Git Alias 语法
sed "s/git //g" temp1.sh > temp2.sh
# 改成GitAlias风格的别名
sed "s/^alias g/git config --global alias./g" temp2.sh > temp3.sh
sed "s/=/ /g" temp3.sh > ${output}
# 进行配置，运行后会注册到 .gitconfig
# source ${output}
# 删除中间文件
rm temp*
