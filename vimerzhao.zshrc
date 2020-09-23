alias j="jump"
export PATH="${PATH}:/usr/local/opt/llvm/bin"
export PATH="${PATH}:~/Install/flutter/bin"
export ANDROID_HOME=/Users/vimerzhao/Library/Android/sdk/
export PATH="${PATH}:${ANDROID_HOME}"
export PATH="${PATH}:${ANDROID_HOME}/platform-tools"
# 所有Bash的共有配置

# ADB
alias v_adb_current_activity="adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp'"
alias v_adb_activity_stack="adb shell dumpsys activity activities | sed -En -e '/Stack #/p' -e '/Running activities/,/Run #0/p'"
alias v_adb_deeplink="adb shell am start -a android.intent.action.VIEW -d"
alias v_adb_screen_record="adb shell screenrecord //mnt/sdcard/demo.mp4"
alias v_adb_pull_record="adb pull //mnt/sdcard/demo.mp4"
alias v_adb_screen_cap="adb shell /system/bin/screencap -p /sdcard/screenshot.png && adb pull /sdcard/screenshot.png"
alias v_adb_push_all_to_photon="adb push * /sdcard/Android/data/com.tencent.android.qqdownloader/files/tassistant/photondebug"


# 博客相关
function v_blog_new_md_post() {
    filename="$1.md"
    echo "# $1" > $filename
    echo "<!--Date:$(date '+%Y-%m-%d')-->" >> $filename
    echo "<!--LinkName:-->" >> $filename
}

## ffmpeg
###~ 把Mac的QuickTime录屏生成的mov转化成占用空间较小的mp4文件
function ffmpeg_mov2mp4() {
    ffmpeg_2mp4 ffmpeg -i $1 -vcodec h264 -acodec mp2 output.mp4
}



# 自定义工具
alias v_jd-gui="java -jar ~/.my-config/tools/jd-gui-1.6.6.jar"
alias v_dex2jar="~/.my-config/tools/dex-tools-2.1-SNAPSHOT/d2j-dex2jar.sh"

# Git命令封装
function v_git_filter_by_author() {
    git log --author="$1" --name-status --diff-filter=A --format='> %aN' | awk '/^>/ {tagline=$0} /^A\t/ {print tagline "\t" $0}'
}
