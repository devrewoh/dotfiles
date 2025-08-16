ChezMoi Dotfiles Overview
=========================

1. Shell environment
-------------------
~/.config/shell/env  -> universal POSIX-compliant environment variables, XDG paths, editor defaults.

2. Shell aliases
----------------
~/.config/shell/aliases -> custom commands and shortcuts

3. Bash/Zsh
-----------
~/.bashrc, ~/.zshrc -> source ~/.config/shell/env for environment variables

4. Editors
----------
- Micro:
  ~/.config/micro/settings.json
  ~/.config/micro/bindings.json
- Neovim / LazyVim:
  ~/.config/nvim/init.lua
  ~/.config/nvim/lua/

5. Terminal
-----------
- Alacritty: ~/.config/alacritty/alacritty.toml
- Tmux: ~/.config/tmux/tmux.conf

6. ASDF / Tool versions
-----------------------
- ASDF global settings: ~/.config/asdf/asdfrc
- Managed versions: ~/.tool-versions

7. Git
------
- ~/.config/git/config
- Commit and push all managed files from ~/.local/share/chezmoi

8. Scripts
----------
- Universal helpers: ~/.local/share/chezmoi/scripts/universal/comprehensive-env-reader.sh

Flow / Mental Model
------------------
1. Source ~/.config/shell/env -> sets environment variables, XDG paths
2. Source shell aliases -> available commands
3. Editor / terminal / tmux / nvim configs are read on launch
4. ASDF / .tool-versions provides language/runtime version management
5. Git configuration centralized in ~/.config/git
6. Everything tracked and deployed via ChezMoi to ensure reproducibility across machines
