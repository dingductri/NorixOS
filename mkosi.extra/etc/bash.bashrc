# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

case "$TERM" in
xterm-color|*-256color) color_prompt=yes;;
esac

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    :
fi

if [ -n "$BASH_VERSION" ]; then
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    fi
fi

[ -f /etc/profile.d/prompt.sh ] && source /etc/profile.d/prompt.sh
