# My Dotfiles

<!--toc:start-->

- [My Dotfiles](#my-dotfiles)
  - [Initializing](#initializing)
  - [Tech](#tech)
  - [Required binaries to install dotfiles](#required-binaries-to-install-dotfiles)
  - [Optional Binaries](#optional-binaries)
  <!--toc:end-->

These are various configuration/dotfiles that I want to use across my machines.

## Initializing

Install/clone into `~/dotfiles` (although can be any directory) directory.

```bash
git clone https://github.com/johnsonjo4531/dotfiles.git ~/dotfiles
```

Then go into the `~/dotfiles` directory (or the directory you chose above instead).

```bash
cd ~/dotfiles
```

Then run `make`

```bash
make
```

Make sure you have something like the following in your ~/.bashrc
(it likely may already be in there. It is at least on fedora.)

```bash
# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc
```

Do the same for these lines but put them in your ~/.profile (if they are not already there.)

```bash
#### Ensure this is in your ~/.profile and uncommented it could already be there though ^\_(0_0)_/^
if [ -d ~/.profile.d ]; then
  for rc in ~/.profile.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc
```

That's it. Now your `~/dotfiles` directory should be symlinked to your home directory!

## Tech

These dotfiles use GNU Stow

## Required binaries to install dotfiles

- git
- stow
- make

## Optional Binaries

These are binaries I usually like to use on my systems

- homebrew
- nvim (neovim)
- tmux
- [sesh](https://github.com/joshmedeski/sesh)
  - requires fzf and zoxide
  - install: `brew install sesh`
- [zoxide](https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation)
  - install `brew install zoxide`
- [git-delta](https://github.com/dandavison/delta)
  - install `brew install git-delta`
- [wezterm](https://github.com/wez/wezterm?tab=readme-ov-file)
- [fzf](https://github.com/junegunn/fzf)
- [bat](https://github.com/sharkdp/bat)
- [starship](https://github.com/starship/starship)
