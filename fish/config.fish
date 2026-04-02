if status is-interactive
    # Commands to run in interactive sessions can go here
alias ls "eza --icons --group-directories-first"
alias Supdate "sudo dnf update"
alias kittythemes "kitty +kitten themes"
alias sourcezsh "source ~/.zshrc"
alias bangers ncmpcpp
alias install "sudo dnf install"
alias remove "sudo dnf remove"
alias search "dnf search"
alias restartwaybar "systemctl --user restart waybar.service"

zoxide init fish | source
    atuin init fish | source
end


# Set up fzf key bindings
fzf --fish | source


