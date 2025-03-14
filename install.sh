#!/usr/bin/env bash

# patch for this issue running nvim in tmux in wezterm: https://github.com/wezterm/wezterm/issues/5007
if [[ -f /etc/profile.d/wezterm.sh ]]; then
  sudo cp ./before_wezterm.sh /etc/profile.d/before_wezterm.sh
fi
