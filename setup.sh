#! /bin/bash

TMP="$HOME/.setup.schlosser.io"
RESOURCES_REMOTE="https://setup.schlosser.io/resources.zip"
RESOURCES="$TMP/resources.zip"
PROGRAMS_REMOTE="https://setup.schlosser.io/programs"
PROGRAMS="$TMP/programs"

function GREEN () {
    echo "\033[0;32m$1\033[0m"
}

function BLUE () {
    echo "\033[0;34m$1\033[0m"
}

function RED () {
    echo "\033[0;31m$1\033[0m"
}

# If the command is already installed, do nothing.  Otherwise, call the install
# function to install this command.
function politeInstall () {
    local commandName=$1
    local installFunction=$2

    if [[ -z $(which $commandName) ]]; then
        printf "$(BLUE "⚒  INSTALLING") $commandName...\n"
        $installFunction
        if [[ -z $(which $commandName) ]]; then
            printf "$(RED "❌  INSTALL FAILED") $commandName\n"
            exit 1
        else
            printf "$(GREEN "✔  INSTALLED") $commandName\n"
        fi
    else
        printf "$(GREEN "✔  ALREADY INSTALLED") $1 ➡ $(which $commandName) \n"
    fi
}

function politeBrewInstall () {
    local packageName=$1
    if [[ $# -eq 2 ]]; then
        local commandName=$2
    else
        local commandName=$packageName
    fi

    if [[ -z $(brew ls --versions $packageName) ]]; then
        printf "$(BLUE "⚒  INSTALLING") $packageName...\n"
        brew install $packageName
        if [[ -z $(brew ls --versions $packageName) ]]; then
            printf "$(RED "❌  INSTALL FAILED") $packageName\n"
            exit 1
        else
            printf "$(GREEN "✔  INSTALLED") $packageName\n"
        fi
    else
        printf "$(GREEN "✔  ALREADY INSTALLED") $packageName ➡ $(which $commandName)\n"
    fi
}

function politeBrewCaskInstall () {
    local caskName=$1
    local appName=$2

    if [[ ! -d "/Applications/$appName" ]]; then
        printf "$(BLUE "⚒  INSTALLING") $caskName...\n"
        brew cask install $caskName
        if [[ ! -d "/Applications/$appName" ]]; then
            printf "$(RED "❌  INSTALL FAILED") $caskName\n"
            exit 1
        else
            printf "$(GREEN "✔  INSTALLED") $caskName\n"
        fi
    else
        printf "$(GREEN "✔  ALREADY INSTALLED") $caskName ➡ /Applications/$appName\n"
    fi
}

function notImplemented () {
    printf "$(RED "❌  NOT IMPLEMENTED") $1\n"
}

function todo () {
    printf "$(BLUE "✔  TODO") $1\n"
}

function installBrew () {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function postInstallBrew () {
    printf "$(BLUE "⚒  POST-INSTALL") Brew...\n"
    brew update
    brew tap caskroom/cask
    printf "$(GREEN "✔  DONE")\n"
}

function preInstallGo () {
    printf "$(BLUE "⚒  PRE-INSTALL") Brew...\n"
    mkdir -p "$HOME/go"
    printf "$(GREEN "✔  DONE")\n"
}

function postInstallSublimeText () {
    printf "$(BLUE "⚒  POST-INSTALL") Sublime Text 3...\n"
    local ST="$HOME/Library/Application Support/Sublime Text 3"
    local packageControl="https://sublime.wbond.net/Package%20Control.sublime-package"
    local dest="$ST/Installed Packages/Package Control.sublime-package"
    if [[ ! -f $dest ]]; then
        curl "$packageControl" > "$dest"
    fi
    cp "$TMP/Package Control.sublime-settings" "$ST/Packages/User/"
    cp "$TMP/Preferences.sublime-settings" "$ST/Packages/User/"
    printf "$(GREEN "✔  DONE")\n"
}

function postInstallBtt () {
    printf "$(BLUE "⚒  POST-INSTALL") BetterTouchTool...\n"
    local BTT="$HOME/Library/Application Support/BetterTouchTool/"
    cp "$TMP/bttdata2" "$BTT/"
    printf "$(GREEN "✔  DONE")\n"
}

function postInstallIterm2 () {
    printf "$(BLUE "⚒  POST-INSTALL") iTerm 2...\n"
    rm -rf $HOME/.iterm2
    cp -r "$TMP/.iterm2" $HOME
    printf "$(GREEN "✔  DONE")\n"
}

function postInstallAlfred () {
    printf "$(BLUE "⚒  POST-INSTALL") Alfred...\n"
    local ALFRED="$HOME/Library/Application Support/Alfred 3/"
    cp -r "$TMP/Alfred.alfredpreferences" "$ALFRED"
    cp "$TMP/license.plist" "$ALFRED"
    printf "$(GREEN "✔  DONE")\n"
}

function postInstallVim () {
    printf "$(BLUE "⚒  POST-INSTALL") Vim...\n"
    cp "$TMP/.vimrc" "$HOME"
    rm -rf "$HOME/.vim"
    cp -r "$TMP/.vim" "$HOME"
    printf "$(GREEN "✔  DONE")\n"
}

function postInstallFonts () {
    printf "$(BLUE "⚒  POST-INSTALL") Fonts...\n"
    local FONTS="$HOME/Library/Fonts"
    cp "$TMP/Fonts.zip" "$FONTS"
    cd "$FONTS" > /dev/null; unzip -qf "Fonts.zip"; cd - > /dev/null
    rm "$FONTS/Fonts.zip"
    printf "$(GREEN "✔  DONE")\n"
}

function postInstallGit () {
    printf "$(BLUE "⚒  POST-INSTALL") Git...\n"
    cp "$TMP/.gitconfig" "$HOME"
    printf "$(GREEN "✔  DONE")\n"
}

function installZsh () {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

function postInstallZsh () {
    printf "$(BLUE "⚒  POST-INSTALL") ZSH...\n"
    cp "$TMP/.zshrc" "$HOME"
    cp "$TMP/danstheme.zsh-theme" "$HOME/.oh-my-zsh/themes"
    printf "$(GREEN "✔  DONE")\n"
}

function postInstallSsh () {
    printf "$(BLUE "⚒  POST-INSTALL") SSH...\n"
    mkdir -p "$HOME/.ssh"
    cp "$TMP/config" "$HOME/.ssh"
    printf "$(GREEN "✔  DONE")\n"
}

############################################################
##                        Commands                        ##
############################################################

function setup () {
    case $1 in
    brew)
        politeInstall brew installBrew
        postInstallBrew
        ;;
    go)
        preInstallGo
        politeBrewInstall go
        ;;
    imagemagick)
        politeBrewInstall imagemagick convert
        ;;
    mongodb)
        politeBrewInstall mongodb mongod
        ;;
    ocaml)
        politeBrewInstall ocaml
        politeBrewInstall opam
        ;;
    openssl)
        politeBrewInstall openssl
        ;;
    pandoc)
        politeBrewInstall pandoc
        ;;
    postgresql)
        politeBrewInstall postgresql psql
        ;;
    python3)
        politeBrewInstall python3
        ;;
    redis)
        politeBrewInstall redis redis-cli
        ;;
    rename)
        politeBrewInstall rename
        ;;
    tree)
        politeBrewInstall tree
        ;;
    sqlite)
        politeBrewInstall sqlite sqlite3
        ;;
    sl)
        politeBrewInstall sl
        ;;
    wget)
        politeBrewInstall wget
        ;;
    alfred)
        politeBrewCaskInstall alfred "Alfred 3.app"
        postInstallAlfred
        ;;
    bettertouchtool)
        politeBrewCaskInstall bettertouchtool "BetterTouchTool.app"
        postInstallBtt
        ;;
    diskInventoryX)
        politeBrewCaskInstall disk-inventory-x "Disk Inventory X.app"
        ;;
    dropbox)
        politeBrewCaskInstall dropbox "Dropbox.app"
        ;;
    firefox)
        politeBrewCaskInstall firefox "Firefox.app"
        ;;
    flux)
        politeBrewCaskInstall flux "Flux.app"
        ;;
    fonts)
        postInstallFonts
        ;;
    git)
        postInstallGit
        ;;
    googleChrome)
        politeBrewCaskInstall google-chrome "Google Chrome.app"
        ;;
    googleDrive)
        politeBrewCaskInstall google-drive "Google Drive.app"
        ;;
    googlePhotosBackup)
        politeBrewCaskInstall google-photos-backup "Google Photos Backup.app"
        ;;
    iterm2)
        politeBrewCaskInstall iterm2 "iTerm.app"
        postInstallIterm2
        ;;
    licecap)
        politeBrewCaskInstall licecap "LICEcap.app"
        ;;
    rdm)
        politeBrewCaskInstall rdm "RDM.app"
        ;;
    rescuetime)
        politeBrewCaskInstall rescuetime "RescueTime.app"
        ;;
    seil)
        politeBrewCaskInstall seil "Seil.app"
        ;;
    sketch)
        politeBrewCaskInstall sketch "Sketch.app"
        ;;
    slack)
        politeBrewCaskInstall slack "Slack.app"
        ;;
    ssh)
        postInstallSsh
        ;;
    sublimeText)
        politeBrewCaskInstall sublimeText "Sublime Text.app"
        postInstallSublimeText
        ;;
    texshop)
        politeBrewCaskInstall texshop "TeX/Texshop.app"
        ;;
    thunderbird)
        politeBrewCaskInstall thunderbird "Thunderbird.app"
        ;;
    utorrent)
        politeBrewCaskInstall utorrent "uTorrent.app"
        ;;
    vlc)
        politeBrewCaskInstall vlc "VLC.app"
        ;;
    vim)
        postInstallVim
        ;;
    zeplin)
        politeBrewCaskInstall zeplin "Zeplin.app"
        ;;
    zsh)
        politeInstall zsh installZsh
        postInstallZsh
        ;;

    notImplemented)
        notImplemented "============================="
        notImplemented "Install Adobe Creative Suite"
        notImplemented "Install Better Snap Tool"
        notImplemented "Install Eclipse"
        notImplemented "Install Finale 2014"
        notImplemented "Install Microsoft Office"
        notImplemented "============================="
        ;;
    todo)
        todo "Sign in to Chrome"
        todo "Sign in to Dropbox"
        todo "Sign in to Google Drive"
        todo "Enter Sketch License Info"
        todo "Enter Sublime Text License Info"
        ;;
    *)
        echo "Command not recognized: $1"
        ;;
    esac
}

function setupall() {
    cat $PROGRAMS | while read line; do
        if [[ $line = \#* ]] ; then
            continue
        elif [[ $line = "" ]] ; then
            continue
        fi
        setup $line
    done
}

printf "$(BLUE "⚒  CREATING") Temporary folder at $TMP...\n"
rm -rf $TMP
mkdir $TMP
printf "$(BLUE "⚒  DOWNLOADING") Resources...\n"
curl -fsSL $RESOURCES_REMOTE > $RESOURCES
cd $TMP > /dev/null; unzip -q $RESOURCES; cd - > /dev/null
# cp -r "$RESOURCES" $TMP

printf "$(BLUE "⚒  DOWNLOADING") Program list...\n"
curl -fsSL $PROGRAMS_REMOTE > $PROGRAMS

while true; do
    printf "$(BLUE "The following programs will be installed:")\n"
    cat $PROGRAMS | while read line; do
        if [[ $line = \#* ]] ; then
            continue
        elif [[ $line = "" ]] ; then
            continue
        fi
        printf "%-8s\n" "${line}"
    done | column
    printf "$(BLUE "Continue? (Continue/Quit/Edit) (c/q/e):") "
    read yn
    case $yn in
        [CcYy]* ) setupall; break;;
        [NnQq]* ) exit;;
        [Ee]* ) vim $PROGRAMS;;
        * ) echo "Please answer yes or no.";;
    esac
done
