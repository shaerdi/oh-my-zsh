# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" != "true" ]
then
  /usr/bin/env ZSH=$ZSH DISABLE_UPDATE_PROMPT=$DISABLE_UPDATE_PROMPT zsh $ZSH/tools/check_for_upgrade.sh
fi

# Initializes Oh My Zsh

# add a function path
fpath=($ZSH/functions $ZSH/completions $fpath)

# Load all of the config files in ~/oh-my-zsh that end in .zsh
# TIP: Add files you don't want in git to .gitignore
for config_file ($ZSH/lib/*.zsh); do
  source $config_file
done

# Set ZSH_CUSTOM to the path where your custom config files
# and plugins exists, or else we will use the default custom/
if [[ -z "$ZSH_CUSTOM" ]]; then
    ZSH_CUSTOM="$ZSH/custom"
fi


is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.zsh \
    || test -f $base_dir/plugins/$name/_$name
}
# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
  if is_plugin $ZSH_CUSTOM $plugin; then
    fpath=($ZSH_CUSTOM/plugins/$plugin $fpath)
  elif is_plugin $ZSH $plugin; then
    fpath=($ZSH/plugins/$plugin $fpath)
  fi
done

# Load and run compinit
autoload -U compinit
compinit -i


# Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins); do
  if [ -f $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
  elif [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH/plugins/$plugin/$plugin.plugin.zsh
  fi
done

# Load all of your custom configurations from custom/
for config_file ($ZSH_CUSTOM/*.zsh(N)); do
  source $config_file
done
unset config_file

# Load the theme
if [ "$ZSH_THEME" = "random" ]
then
  themes=($ZSH/themes/*zsh-theme)
  N=${#themes[@]}
  ((N=(RANDOM%N)+1))
  RANDOM_THEME=${themes[$N]}
  source "$RANDOM_THEME"
  echo "[oh-my-zsh] Random theme '$RANDOM_THEME' loaded..."
else
  if [ ! "$ZSH_THEME" = ""  ]
  then
    if [ -f "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme" ]
    then
      source "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme"
    else
      source "$ZSH/themes/$ZSH_THEME.zsh-theme"
    fi
  fi
fi


MARKPATH=$ZSH/custom/marks
mkdir -p $MARKPATH
# Add some static entries
hash -d log=/var/log
hash -d doc=/usr/share/doc

# Populate the hash
for link ($MARKPATH/*(N@)) {
    hash -d -- -${link:t}=${link:A}
}

vbe-insert-bookmark() {
    emulate -L zsh
    LBUFFER=${LBUFFER}"~-"
}
zle -N vbe-insert-bookmark
bindkey '@@' vbe-insert-bookmark

# Manage bookmarks
bookmark() {
    [[ -d $MARKPATH ]] || mkdir -p $MARKPATH
    if (( $# == 0 )); then
        # When no arguments are provided, just display existing
        # bookmarks
        for link in $MARKPATH/*(N@); do
            local markname="$fg[green]${link:t}$reset_color"
            local markpath="$fg[blue]${link:A}$reset_color"
            printf "%-30s -> %s\n" $markname $markpath
        done
    else
        # Otherwise, we may want to add a bookmark or delete an
        # existing one.
        local -a delete
        zparseopts -D d=delete
        if (( $+delete[1] )); then
            # With `-d`, we delete an existing bookmark
            command rm $MARKPATH/$1
        else
            # Otherwise, add a bookmark to the current
            # directory. The first argument is the bookmark
            # name. `.` is special and means the bookmark should
            # be named after the current directory.
            local name=$1
            [[ $name == "." ]] && name=${PWD:t}
            ln -s $PWD $MARKPATH/$name
            hash -d -- -${name}=${PWD}
        fi
    fi
}
