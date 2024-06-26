#!/usr/bin/env bash
#
# yes this is yoinked from https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5
#
# I believe there are a few ways to do this:
#
#    1. My current way, using a minimal /etc/nixos/configuration.nix that just imports my config from my home directory (see it in the gist)
#    2. Symlinking to your own configuration.nix in your home directory (I think I tried and abandoned this and links made relative paths weird)
#    3. My new favourite way: as @clot27 says, you can provide nixos-rebuild with a path to the config, allowing it to be entirely inside your dotfies, with zero bootstrapping of files required.
#       `nixos-rebuild switch -I nixos-config=path/to/configuration.nix`
#    4. If you uses a flake as your primary config, you can specify a path to `configuration.nix` in it and then `nixos-rebuild switch —flake` path/to/directory
# As I hope was clear from the video, I am new to nixos, and there may be other, better, options, in which case I'd love to know them! (I'll update the gist if so)

# A rebuild script that commits on a successful build
set -e

# cd to your config dir
pushd ~/nixos-gubbins/nixos-config

if  [[ "$@" =~ "p" ]];then
	git pull
fi

# Edit your config
# $EDITOR ~/nixos-gubbins/nixos-config/hosts/home.nix
sudo code ~/nixos-gubbins/nixos-config/nixos-config.code-workspace --wait --no-sandbox --user-data-dir

# Early return if no changes were detected (thanks @singiamtel!)
if ! [[ "$@" =~ "rebuild" ]] && git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
sudo alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch --flake .# # &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# restart de, just in case krunner has broke
systemctl --user restart plasma-plasmashell 

# Get current generation metadata
current=$(nixos-rebuild --flake .# list-generations | grep current)
system=$(neofetch --stdout | grep -o -m 1 '@.*')

# Commit all changes witih the generation metadata
git commit -am "$system $current"

# Notify all OK!
notify-send -e "NixOS Rebuilt OK awaiting key for push" --icon=software-update-available

git push

# Back to where you were
popd
