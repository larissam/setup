# cribbed from the gnzh theme
# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

# add in a function to print out virtualenv information
function virtualenv_info {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo '('`basename $VIRTUAL_ENV`') '
    fi
}

# make some aliases for the colours: (could use normal escape sequences too)
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
  eval PR_BOLD_$color='%{$fg_bold[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

# Check the UID
if [[ $UID -ge 0 ]]; then # normal user
  eval PR_USER='${PR_BOLD_GREEN}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
  local PR_PROMPT='%{$PR_CYAN%}➤%{$PR_NO_COLOR%}${PR_BOLD_BLUE}$%{$PR_NO_COLOR%}'
elif [[ $UID -eq 0 ]]; then # root
  eval PR_USER='${PR_BOLD_RED}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_RED➤$ $PR_NO_COLOR'
fi

eval PR_HOST='${PR_GREEN}%M${PR_NO_COLOR}'

local return_code="%(?..%{$PR_RED%}%? ↵%{$PR_NO_COLOR%})"

local user_host='${PR_USER}${PR_BOLD_GREEN}@${PR_HOST}'
#local current_dir='%{$PR_BOLD$PR_BLUE%}%~%{$PR_NO_COLOR%}'
local current_dir='%{$PR_BOLD_BLUE%}%d%{$PR_NO_COLOR%}'
local git_branch='$(git_prompt_info)%{$PR_NO_COLOR%}'

local virtualenv_info='%{$PR_MAGENTA%}$(virtualenv_info)%{$PR_NO_COLOR%}'

PROMPT="%{$PR_CYAN%}╭─%{$PR_NO_COLOR%}${user_host}:${current_dir} ${git_branch}${virtualenv_info}
%{$PR_CYAN%}╰─%{$PR_NO_COLOR%}$PR_PROMPT "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_GREEN%}[git: ⭠ "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$PR_GREEN%}] %{$PR_NO_COLOR%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$PR_RED%}✭"
#ZSH_THEME_GIT_PROMPT_CLEAN=" %{$PR_GREEN%}✔"
