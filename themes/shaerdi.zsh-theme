PROMPT='%% '
RPROMPT='%~$(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}/[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="]%{$fg[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="]"

# Vi Mode
#RPROMPT='$(vi_mode_prompt_info)%{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
#MODE_INDICATOR="%{$fg_bold[red]%}n%{$reset_color%}"
