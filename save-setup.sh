#! /bin/bash

function GREEN () {
    echo "\033[0;32m$1\033[0m"
}

function BLUE () {
    echo "\033[0;34m$1\033[0m"
}

function RED () {
    echo "\033[0;31m$1\033[0m"
}

function saving () {
    printf "$(BLUE "⚒  SAVING") $1...\n"
}

function save () {
    local from=$1
    printf "$(GREEN "✔  SAVED") $(basename "$1")\n"
    cp -r "$1" "$TMP"
}

function saveCompressed () {
    local from=$1
    printf "$(BLUE "⚒  SAVING COMPRESSED") $(basename "$from")...\n"
    cd "$from" > /dev/null; zip -qr "$TMP/$(basename "$from").zip" *; cd - > /dev/null
    printf "$(GREEN "✔  SAVED") $(basename "$from") ➡ "$(basename "$1").zip"\n"
}

function todo () {
    printf "$(BLUE "✔  TODO") $1\n"
}

TMP="$HOME/.current-setup.schlosser.io"
ZIP="$TMP/resources.zip"
mkdir -p "$TMP"

SUBLIME="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
ALFRED="$HOME/Library/Application Support/Alfred 3"
BTT="$HOME/Library/Application Support/BetterTouchTool/"


save "$SUBLIME/Package Control.sublime-settings"
save "$SUBLIME/Preferences.sublime-settings"
save "$HOME/.gitconfig"
save "$HOME/.iterm2"
save "$HOME/.zshrc"
save "$ALFRED/Alfred.alfredpreferences"
save "$ALFRED/license.plist"
save "$HOME/.ssh/config"
save "$HOME/.vimrc"
save "$HOME/.vim"
save "$HOME/.zshrc"
save "$HOME/.oh-my-zsh/themes/danstheme.zsh-theme"
saveCompressed "$HOME/Library/Fonts"
save "$BTT/bttdata2"

printf "$(BLUE "⚒  UPLOADING PACKAGE...")\n"
cd "$TMP" > /dev/null; zip -qr "$ZIP" *.*; cd - > /dev/null
scp "$ZIP" dan:/srv/setup.schlosser.io/public_html/
rm "$ZIP"

