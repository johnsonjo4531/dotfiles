# shellcheck shell=bash

# -v checks whether or not the variable exists
if [[ -v TMUX ]] && [[ -v NVIM ]]; then
  export WEZTERM_SHELL_SKIP_ALL="1"
fi
