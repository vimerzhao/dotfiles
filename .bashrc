
# Ref:
#   https://developer.android.com/studio/debug/am-logcat
#   https://en.wikipedia.org/wiki/ANSI_escape_code

# 输出日志
clog() {
    # TODO 为什么 \o33和\x1b可以，\033不行（但在echo命令中又可以）
    grep --line-buffered -E $1 | sed  -e "s/^.*\sV\s.*$/\x1b[37m&\x1b[0m/" \
                                                -e "s/^.*\sD\s.*$/\x1b[34m&\x1b[0m/" \
                                                -e "s/^.*\sI\s.*$/\x1b[32m&\x1b[0m/" \
                                                -e "s/^.*\sW\s.*$/\x1b[33m&\x1b[0m/" \
                                                -e "s/^.*\sE\s.*$/\x1b[31m&\x1b[0m/" \
                                                -e "s/^.*\sA\s.*$/\x1b[35m&\x1b[0m/"    # 预定义，可根据需要定制Tag的颜色
}
# 使用Tail，既保存日志又输出日志~尤其是Crash闪退的时候

# http://jafrog.com/2013/11/23/colors-in-terminal.html
printDailyUseColor() {
    for code in {30..37}; do \
        echo -en "\e[${code}m"'\\e['"$code"'m'"\e[0m"; \
        echo -en "  \e[$code;1m"'\\e['"$code"';1m'"\e[0m"; \
        echo -en "  \e[$code;3m"'\\e['"$code"';3m'"\e[0m"; \
        echo -en "  \e[$code;4m"'\\e['"$code"';4m'"\e[0m"; \
        echo -e "  \e[$((code+60))m"'\\e['"$((code+60))"'m'"\e[0m"; \
    done
}

# 光子发布脚本releaseRapid
releaseRapid() {
    if !(command -v 7z >/dev/null 2>&1); then
        echo "7z 不存在"
        return
    fi
    if !(command -v luac >/dev/null 2>&1); then
        echo "luac 不存在"
        return
    fi

    # TODO 配置luac和zip的环境变量
    out=${PWD##*/}"_release"

    # 创建工作空间
    if [ -d $out ]; then
        rm -rf $out
        echo -e 删除已经存在的目录'\t\t'$out
    fi
    mkdir $out


    for f in ./*; do
        if test -f $f; then
            if [ "${f##*.}" == "lua" ]; then 
                # 编译Lua文件
                echo -e 编译lua脚本'\t\t\t'$f
                f1=${f%.lua*}".out"
                luac -o $out/$f1 $f
            elif [ "${f##*.}" == "xml" ]; then
                # 删除xml文件的注释，注意不要使用跨行注释
                # 删除空行
                # 替换lua为out，不要再xml随意使用lua这个词，当做保留字
                echo -e 删除空行注释，替换后缀'\t\t'$f
                cat $f | sed '/<!--.*-->/d' | sed '/^$/d' | sed 's/\.lua/\.out/g' > $out/$f
            else
                # 其他文件平移，所以要保持目录干净
                echo -e 平移其他文件'\t\t\t'$f
                cp $f ./$out/
            fi
        elif test -d $f; then
            # 字符串处理
            if [ "$f" == "./$out" ]; then
                # 该目录不移动
                echo -e 跳过目标目录'\t\t\t'$f
            elif [ "$f" == "./doc" ]; then
                # 该目录不移动,这个目录用来存放设计图等文档
                echo -e 跳过文档存放目录'\t\t\t'$f
            else
                echo -e 平移其他目录'\t\t\t'$f
                cp -rf ./$f ./$out/
            fi
        fi
    done

    cd $out
    echo "=========================开始打包RuntimeView========================="
    7z a $out".zip"
    cd ..
}

# 清理发布目录
clearReleaseFolder() {
    out=${PWD##*/}"_release"
    if [ -d $out ]; then
        rm -rf $out
    fi
}

# 替换文本和图片，方便没有后台数据时测试使用
trick() {
    sed -i "s/text=\"data@[^\"]*/&DEBUG$换行超长字符串测试-换行超长字符串测试#换行超长字符串测试DEBUG/g" *.xml
    sed -i "s/00ff0001/ff0001/g" *.xml
}
detrick() {
    sed -i "s/DEBUG.*DEBUG//g" *.xml
    sed -i "s/ff0001/00ff0001/g" *.xml
}

# 一些adb命令的简写
alias current_activity="adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp'"
