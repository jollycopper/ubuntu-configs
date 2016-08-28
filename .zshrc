# Path to your oh-my-zsh installation.
  export ZSH=/home/ian/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="fishy"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/ian/config/scripts:/home/ian/Android/Sdk/platform-tools:/home/ian/depot_tools"
# export MANPATH="/usr/local/man:$MANPATH"

export EDITOR="vim"

source $ZSH/oh-my-zsh.sh

# Git branch in prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

alias l="ls -CF"
alias gg='git grep'
alias ggi='git grep -i'
alias gg2="git grep -C2"
alias gg3="git grep -C3"
alias gg4="git grep -C4"

# Find by exact filename
fne() {
  local filename="$1"
  shift
  if [[ "$filename" = */* ]]; then
    find -path "*${filename}" "$@"
  else
    find -name "${filename}" "$@"
  fi
}

# Find by case-insensitive partial filename
fn() {
  [[ $# -eq 0 ]] && return
  local filename="$1"
  shift
  if [[ "$filename" = */* ]]; then
    find -iwholename "*${filename}*" "$@"
  else
    find -iname "${filename}*" "$@"
  fi
}

# Find and replace across a git repository. Examples:
#
#   git-replace oldMethodName newMethodName
#   git-replace '#include "base/md5.h"' '#include "base/crypto/md5.h"'
#
# You can also use a git pathspec to limit the files that will be searched:
#
#   git-replace oldMethod newMethod -- "base/*.cc"
#
git-replace() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: git-replace <query> <replacement> [<pathspec>...]"
    return
  fi
  local query=$1
  # Escape special characters so sed treats these as fixed strings.
  # Characters escaped in the query: ] \ / $ * . ^ | [
  # Characters escaped in the replacement: \ / &
  # See: http://stackoverflow.com/a/2705678/598094
  local escaped_query=$(echo $1 | sed -e 's/[]\/$*.^|[]/\\&/g')
  local escaped_replacement=$(echo $2 | sed -e 's/[\/&]/\\&/g')
  shift 2
  git grep -lF "$query" -- "$@" \
      | xargs sed -i "s/${escaped_query}/${escaped_replacement}/g"
}
