#!/bin/bash

# Ensure .config directory exists
if [ ! -d "$HOME/.config" ]; then
  echo "Creating $HOME/.config directory..."
  mkdir -p "$HOME/.config"
fi

# Check flags
r_flag=""

print_usage() {
  printf "\nUsage:\n\t$0 [FLAGS]\n\nFLAGS:\n-r\treverse (unlinks all the symlinks)\n\n"
}

while getopts 'rh' flag; do
  case "${flag}" in
    r) r_flag="true" ;;
    h) print_usage
       exit 1 ;;
  esac
done

# Check OS
# 
# Credits to https://stackoverflow.com/users/14860/paxdiablo for this snippet

unameOut="$(uname -s)"

case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# Initialize parallel arrays for sources and targets
sources=()
targets=()

# Define the symlinks sources and targets

if [ "$machine" = "Linux" ]; then

  echo "Linux detected.."

  # tmux
  sources+=(".tmux.conf")
  targets+=("$HOME/.tmux.conf")

  # X11
  sources+=(".xinitrc")
  targets+=("$HOME/.xinitrc")

  # bash
  sources+=(".bashrc")
  targets+=("$HOME/.bashrc")

  sources+=(".bash_profile")
  targets+=("$HOME/.bash_profile")

  # surf browser
  sources+=(".surf")
  targets+=("$HOME/.surf")

  # alacritty terminal
  sources+=(".config/alacritty")
  targets+=("$HOME/.config/alacritty")

  # dunst notifications
  sources+=(".config/dunst")
  targets+=("$HOME/.config/dunst")

  # eww widgets
  sources+=(".config/eww")
  targets+=("$HOME/.config/eww")

  # fonts for eww
  sources+=("fonts")
  targets+=("$HOME/.local/share/fonts")

  # mpv media player
  sources+=(".config/mpv")
  targets+=("$HOME/.config/mpv")

  # redshift color temperature
  sources+=(".config/redshift")
  targets+=("$HOME/.config/redshift")

  # zathura PDF viewer
  sources+=(".config/zathura")
  targets+=("$HOME/.config/zathura")

  # MangoHud overlay
  sources+=(".config/MangoHud")
  targets+=("$HOME/.config/MangoHud")

  # picom compositor
  sources+=(".config/picom.conf")
  targets+=("$HOME/.config/picom.conf")

  # linux scripts
  sources+=("scripts")
  targets+=("$HOME/.local/scripts")

  # wofi
  sources+=(".config/wofi")
  targets+=("$HOME/.config/wofi")

  # niri
  sources+=(".config/niri")
  targets+=("$HOME/.config/niri")

  # swaylock
  sources+=(".config/swaylock")
  targets+=("$HOME/.config/swaylock")

  # waybar
  sources+=(".config/waybar")
  targets+=("$HOME/.config/waybar")

  # mako
  sources+=(".config/mako")
  targets+=("$HOME/.config/mako")

  # hyprland
  sources+=(".config/hypr")
  targets+=("$HOME/.config/hypr")

  # fontconfig
  sources+=(".config/fontconfig")
  targets+=("$HOME/.config/fontconfig")

  # kitty
  sources+=(".config/kitty")
  targets+=("$HOME/.config/kitty")

  # GTK2
  sources+=(".gtkrc-2.0")
  targets+=("$HOME/.gtkrc-2.0")

  # GTK3
  sources+=(".config/gtk-3.0")
  targets+=("$HOME/.config/gtk-3.0")

  # background image
  sources+=("bg.jpg")
  targets+=("$HOME/.config/bg")

elif [ "$machine" = "Mac" ]; then

  echo "MacOS detected.."

  # zsh shell
  sources+=("mac/.zshrc")
  targets+=("$HOME/.zshrc")

  sources+=("mac/.zprofile")
  targets+=("$HOME/.zprofile")

  # tmux
  sources+=("mac/.tmux.conf")
  targets+=("$HOME/.tmux.conf")

  # alacritty terminal
  sources+=("mac/.config/alacritty")
  targets+=("$HOME/.config/alacritty")

  # leader key
  sources+=("mac/Library/Application Support/Leader Key")
  targets+=("$HOME/Library/Application Support/Leader Key")

  # local scripts
  sources+=("mac/.local/bin")
  targets+=("$HOME/.local/bin")

  # background image
  sources+=("bg.jpg")
  targets+=("$HOME/Pictures/bg.jpg")

fi

# Configs common to both platforms

# pip package manager
sources+=(".config/pip")
targets+=("$HOME/.config/pip")

# helix editor
sources+=(".config/helix")
targets+=("$HOME/.config/helix")

# zed editor
sources+=(".config/zed")
targets+=("$HOME/.config/zed")

# neovim editor
sources+=(".config/nvim")
targets+=("$HOME/.config/nvim")

# yazi file manager
sources+=(".config/yazi")
targets+=("$HOME/.config/yazi")

# Check if symlinks need to be removed on linked

if [ "$r_flag" = "true" ]; then
  echo "Unlinking the symlinks.."

  for i in "${!sources[@]}"; do
    echo "${targets[$i]}"
    unlink "${targets[$i]}"
  done

  exit 0
fi

# Create the links

for i in "${!sources[@]}"; do

  echo "Linking $(pwd)/${sources[$i]} -> ${targets[$i]}"

  # Check if the directory exists
  if [ -d "${targets[$i]}" ]; then 
    if [ -L "${targets[$i]}" ]; then
      unlink "${targets[$i]}"
    else
      rm -rf "${targets[$i]}"
    fi
  fi

  ln -sf "$(pwd)/${sources[$i]}" "${targets[$i]}"
done

