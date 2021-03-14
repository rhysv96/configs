# vim:ft=zsh ts=2 sw=2 sts=2

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"
VIM_NORMAL_PROMPT="%{$fg_bold[yellow]%}[% N]% %{$reset_color%}"
VIM_INSERT_PROMPT="%{$fg_bold[grey]%}[% I]% %{$reset_color%}"
function vim_prompt {
  echo "${${${KEYMAP:=main}/vicmd/$VIM_NORMAL_PROMPT}/(main|viins)/$VIM_INSERT_PROMPT}"
}

PROMPT='
%{$fg_bold[green]%}%~%{$reset_color%}$(git_prompt_info) ⌚ %{$fg_bold[red]%}%*%{$reset_color%} 
$(vim_prompt) '

RPROMPT='$(ruby_prompt_info)'

