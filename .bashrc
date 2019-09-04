
# Ref:
#   https://developer.android.com/studio/debug/am-logcat
#   https://en.wikipedia.org/wiki/ANSI_escape_code

# http://jafrog.com/2013/11/23/colors-in-terminal.html

# START 通用
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# https://en.wikipedia.org/wiki/ANSI_escape_code

printDailyUseColor() {
    for code in {30..37}; do \
        echo -en "\e[${code}m"'\\e['"$code"'m'"\e[0m"; \
        echo -en "  \e[$code;1m"'\\e['"$code"';1m'"\e[0m"; \
        echo -en "  \e[$code;3m"'\\e['"$code"';3m'"\e[0m"; \
        echo -en "  \e[$code;4m"'\\e['"$code"';4m'"\e[0m"; \
        echo -e "  \e[$((code+60))m"'\\e['"$((code+60))"'m'"\e[0m"; \
    done
}


    # Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White
# END


# START 光子开发相关
releaseRapid() { # 光子发布脚本releaseRapid
    if ! (command -v 7z >/dev/null 2>&1); then
        echo "7z 不存在"
        return
    fi
    if ! (command -v luac >/dev/null 2>&1); then
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
    if (( "$#" <= "0" )); then
        echo process all
        sed -i "s/text=\"data@[^\"]*/&DEBUG$换行超长字符串测试-换行超长字符串测试#换行超长字符串测试DEBUG/g" *.xml
        sed -i "s/00ff0101/ff0101/g" *.xml
    else
        for f in $*; do
            echo process $f
            sed -i "s/text=\"data@[^\"]*/&DEBUG$换行超长字符串测试-换行超长字符串测试#换行超长字符串测试DEBUG/g" $f
            sed -i "s/00ff0101/ff0101/g" $f
        done
    fi
}
detrick() {
    if (( "$#" <= "0" )); then
        echo process all
        sed -i "s/DEBUG.*DEBUG//g" *.xml
        sed -i "s/ff0101/00ff0101/g" *.xml
    else
        for f in $*; do
            echo process $f
            sed -i "s/DEBUG.*DEBUG//g" $f
            sed -i "s/ff0101/00ff0101/g" $f
        done
    fi
}

# START Android通用
# 一些adb命令的简写
alias current_activity="adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp'"
alias activity_stack="adb shell dumpsys activity activities | sed -En -e '/Stack #/p' -e '/Running activities/,/Run #0/p'"
alias pullHuaweiScreenshots="adb pull  sdcard/Pictures/Screenshots/" # 获取华为测试机的全部截图

alias deeplink="adb shell am start -a android.intent.action.VIEW -d"
alias ass="adb shell screenrecord //mnt/sdcard/demo.mp4"
alias aps="adb pull //mnt/sdcard/demo.mp4"

clog() { # 输出日志
    # TODO 为什么 \o33和\x1b可以，\033不行（但在echo命令中又可以）
    grep --line-buffered -E $1 | sed  -e "s/^.*\sV\s.*$/\x1b[37m&\x1b[0m/" \
                                      -e "s/^.*\sD\s.*$/\x1b[35m&\x1b[0m/" \
                                      -e "s/^.*\sI\s.*$/\x1b[32m&\x1b[0m/" \
                                      -e "s/^.*\sW\s.*$/\x1b[33m&\x1b[0m/" \
                                      -e "s/^.*\sE\s.*$/\x1b[31m&\x1b[0m/" \
                                      -e "s/^.*\sA\s.*$/\x1b[35m&\x1b[0m/"    # 预定义，可根据需要定制Tag的颜色
} # 使用Tail，既保存日志又输出日志~尤其是Crash闪退的时候
# END

# START FFmpeg常用
export ffmpeg="/d/ffmpeg/bin/ffmpeg.exe"
alias v2f="$ffmpeg -i demo.mp4 %d.jpg" # video to frame 视频分帧，用于调试一些动画问题
# END



# START 应用宝相关
killYYB() {
    adb shell am force-stop com.tencent.android.qqdownloader 
}
rmLaunchLog() { # 做下载速度的时候添加的
    adb shell rm '//mnt/sdcard/tencent/tassistant/log/LaunchSpeedFLog'
}

getLaunchLog() {
    versionName=`adb shell dumpsys package com.tencent.android.qqdownloader | grep versionName`
    adb pull '//mnt/sdcard/tencent/tassistant/log/LaunchSpeedFLog' LaunchSpeedFLog${versionName:16}
}


launchYYB() {
    adb shell am start -n com.tencent.android.qqdownloader/com.tencent.pangu.link.SplashActivity
}

# END

# START Git相关 
# 缩写注意保持和 https://github.com/robbyrussell/oh-my-zsh/wiki/Cheatsheet#git 的风格保持一致
alias ga="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gcb="git checkout -b"
# https://stackoverflow.com/questions/1146973/how-do-i-revert-all-local-changes-in-git-managed-project-to-previous-state
alias gcd="git checkout ."
alias gp="git pull"
alias gpr="git pull --rebase"
alias gs="git status"

# 时间格式定制 https://stackoverflow.com/questions/7853332/how-to-change-git-log-date-formats
# 同步分支 https://stackoverflow.com/questions/6373277/synchronizing-a-local-git-repository-with-a-remote-one
# for-each-ref命令 https://git-scm.com/docs/git-for-each-ref
# https://stackoverflow.com/questions/21256861/what-are-valid-fields-for-the-format-option-of-git-for-each-ref
# https://git-scm.com/book/en/v2/Git-Internals-Git-References
branchLife() { # 查看分支最后提交人和存活周期
    git fetch --prune
    git for-each-ref --sort='-committerdate' --format="%(refname:short) %09 %(authorname) %09 %(committerdate:relative)"  \
        | grep  --line-buffered "origin" \
        | awk '{printf "%-50s%-25s%s %s %s\n",$1,$2,$3,$4,$5}' \
        | sed  -e "s/^.*\sweeks\s.*$/\x1b[35m&\x1b[0m/"  -e "s/^.*\smonths\s.*$/\x1b[31m&\x1b[0m/"
    #    | sed  -e "s/^.* weeks .*$/${esc}[35m&${esc}[0m/"  -e "s/^.* months .*$/${esc}[31m&${esc}[0m/"
    # mac zsh上不行，为什么~~  需要查明 ${esc}  \x1b \011 的区别
}

gitLog() { # 高度格式化的日志阅读格式
    git log --graph --abbrev-commit --decorate  --first-parent $*
}
# END
echo finish

setUpMac() {
    export PATH=$PATH:/Users/vimerzhao/Library/Android/sdk/platform-tools
}

setUpMac
