if status is-interactive
    set -gx EDITOR nvim
    set fish_greeting
    starship init fish | source
end

# Created by 'pipx' on 2026-07-29 11:24:53
set PATH $PATH /home/idk/.local/bin

alias clips="cliphist list | fzf | cliphist decode | wl-copy"
