if [ $commands[autojump] ]; then # check if autojump is installed
  if [ -f /usr/share/autojump/autojump.zsh ]; then # debian and ubuntu package
    . /usr/share/autojump/autojump.zsh
  elif [ -f /etc/profile.d/autojump.zsh ]; then # manual installation
    . /etc/profile.d/autojump.zsh
  elif [[ -n $commands[brew] ]] && [ $commands[brew] -a -f `brew --prefix`/etc/autojump ]; then # mac os x with brew
    . `brew --prefix`/etc/autojump
  fi
fi
