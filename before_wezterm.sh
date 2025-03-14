# shellcheck shell=bash

# -f checks whether or not the file exists
if [[ -v TMUX ]] && [[ -v NVIM ]]; then
  export WEZTERM_SHELL_SKIP_ALL="1"
fi
