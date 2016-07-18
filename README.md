[Setup a new Mac](https://setup.schlosser.io/)
==============================================

No more installing, or configuring. Automatically install and configure
programs to make any Mac feel like home.

Setup
-----

    sh -c "$(curl -fsSL https://setup.schlosser.io/setup)"

Save Configurations
-------------------

    sh -c "$(curl -fsSL https://setup.schlosser.io/save)"

Deploy this Repo
----------------
Made changes to this repo itself?  Use this command to upload them.  (Assumes `dan` in SSH config):

```
scp setup save programs index.html dan:/srv/setup.schlosser.io/public_html/
```

Full program list
-----------------

### Command Line

-   brew
-   imagemagick
-   openssl
-   pandoc
-   rename
-   tree
-   wget
-   sl
-   ssh
-   vim
-   zsh

### Programming

-   git
-   go
-   mongodb
-   ocaml
-   postgresql
-   python3
-   redis
-   sqlite

### Utilities

-   Better Touch Tool
-   Disk Inventory X
-   Flux
-   System Fonts
-   LICEcap
-   RDM
-   RescueTime
-   Seil

### Applications

-   Alfred
-   Dropbox
-   Firefox
-   Google Chrome
-   Google Drive
-   Google Photos Backup
-   iTerm 2
-   Sketch
-   Slack
-   Sublime Text 3
-   TEXshop
-   Thunderbird
-   uTorrent
-   VLC
-   Zeplin

Screenshots
-----------
![My Terminal Setup](http://static.schlosser.io/ss/dotfiles/terminal.png)
![My Vim Setup](http://static.schlosser.io/ss/dotfiles/vim.png)
