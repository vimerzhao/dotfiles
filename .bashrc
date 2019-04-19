
# Ref:
#   https://developer.android.com/studio/debug/am-logcat
#   https://en.wikipedia.org/wiki/ANSI_escape_code

# 输出日志
clog() {
    # TODO 为什么 \o33和\x1b可以，\033不行（但在echo命令中又可以）
    # TODO 这种写法为什么失败了 adb logcat | grep $1 | sed -e "s/^.*I.*$/\\${FG_Green} & \\${NC}/"
    adb logcat | grep --line-buffered -E $1 | sed  -e "s/^.*\sV\s.*$/\x1b[37m&\x1b[0m/" \
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
