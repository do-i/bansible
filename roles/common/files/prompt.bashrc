BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)
if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
  PS1='\[${YELLOW}\][`date +"%H:%M"`] \[${GREEN}\]\u@\h:\w\[${POWDER_BLUE}\]`__git_ps1` \[${GREEN}\]\n$ \[${NORMAL}\]'
else
  PS1='\[${YELLOW}\][`date +"%H:%M"`] \[${GREEN}\]\u@\h:\w\[${POWDER_BLUE}\] \[${GREEN}\]\n$ \[${NORMAL}\]'
fi
