#!/usr/bin/env bash

# include my library helpers for colorized running and require_brew, etc
source ./lib.sh

# Final script should install
# Moom, RescueTime, DropBox, Caffiene
# Mac Defaults (fast key repeat)
# zshrc defaults
# command line utilities (python with correct versions)
# set finder prefrences correctly

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
# Ask for the administrator password upfront
bot "I need you to enter your sudo password so I can install some things:"
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

bot "OK, let's roll..."
 
# Some things taken from here
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx
# Others from here:
# https://github.com/atomantic/dotfiles/blob/master/osx.sh

################################################
bot "Standard System Changes"
################################################
running "always boot in verbose mode (not OSX GUI mode)"
sudo nvram boot-args="-v";ok
 
running "This script will make your Mac awesome"

running "What would you like the name of this computer to be?"
read COMPUTER_NAME
sudo scutil --set ComputerName $COMPUTER_NAME;ok
sudo scutil --set HostName $COMPUTER_NAME;ok
sudo scutil --set LocalHostName $COMPUTER_NAME;ok
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME;ok

 
###############################################################################
# General UI/UX
###############################################################################
 
running "Hide the Time Machine, Volume, User, and Bluetooth icons"
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
  defaults write "${domain}" dontAutoLoad -array \
    "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"
done
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu" \
  "/System/Library/CoreServices/Menu Extras/Displays.menu"
ok

running "Excluding mounted volumes from SpotLight search."
defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes";ok


running "Disabling OS X Gate Keeper"
running "(You'll be able to install any app you want from here on, not just Mac App Store apps)"
sudo spctl --master-disable;ok
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no;ok
defaults write com.apple.LaunchServices LSQuarantine -bool false;ok
 
running "Increasing the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001;ok
 
running "Expanding the save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true;ok
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true;ok
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true;ok
 
running "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true;ok
 
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
running "Displaying ASCII control characters using caret notation in standard text views"
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true;ok
 
running "Disabling system-wide resume"
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false;ok
 
running "Disabling automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true;ok
 
running "Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false;ok
 
running "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName;ok
 
running "Never go into computer sleep mode"
systemsetup -setcomputersleep Off > /dev/null;ok
 
running "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1;ok
 
running "Disable smart quotes and smart dashes as theyâ€™re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false;ok
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false;ok
 
 
###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################
 
running "Increasing sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40;ok
 
running "Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3;ok
 
running "Disabling press-and-hold for keys in favor of a key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false;ok
 
running "Setting a blazingly fast keyboard repeat rate (ain't nobody got time fo special chars while coding!)"
defaults write NSGlobalDomain KeyRepeat -int 0;ok
 
running "Disabling auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false;ok
 
running "Setting trackpad & mouse speed to a reasonable number"
defaults write -g com.apple.trackpad.scaling 1;ok
defaults write -g com.apple.mouse.scaling 1;ok
 
running "Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300;ok

running "Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true;ok
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1;ok
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1;ok
 


###############################################################################
# Screen
###############################################################################
 
running "Disabling automatic adjustment of display backlight."
defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool false;ok

running "Disabling automatic adjustment of keyboard backlight."
defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool false;ok

running "Requiring password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1;ok
defaults write com.apple.screensaver askForPasswordDelay -int 0;ok
 
running "Enabling subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2;ok
 
running "Enable HiDPI display modes (requires restart)"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true;ok
 
###############################################################################
# Finder
###############################################################################
 
running "Showing icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true;ok

running "Show hidden files in Finder by default"
defaults write com.apple.Finder AppleShowAllFiles -bool true;ok
 
running "Show dotfiles in Finder by default"
defaults write com.apple.finder AppleShowAllFiles TRUE;ok

running "Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true;ok
 
running "Showing status bar in Finder by default"
defaults write com.apple.finder ShowStatusBar -bool true;ok

running "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true;ok
 
running "Allowing text selection in Quick Look/Preview in Finder by default"
defaults write com.apple.finder QLEnableTextSelection -bool true;ok
 
running "Displaying full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true;ok
 
running "Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false;ok
 
running "Use column view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle Clmv;ok
 
running "Avoiding the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true;ok
 
running "Disabling disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true;ok
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true;ok
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true;ok
 
running "Enabling snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist;ok
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist;ok
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist;ok

running "Show the ~/Library folder"
chflags nohidden ~/Library;ok

running "Expand the following File Info panes:"
running "General, Open With, Sharing and Permissions"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true;ok


###############################################################################
# Dock & Mission Control
###############################################################################
 
# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you donâ€™t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array
 
running "Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36;ok
 
running "Speeding up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1;ok
defaults write com.apple.dock "expose-group-by-app" -bool true;ok
 
running "Setting Dock to auto-hide and removing the auto-hiding delay"
defaults write com.apple.dock autohide -bool true;ok
defaults write com.apple.dock autohide-delay -float 0;ok
defaults write com.apple.dock autohide-time-modifier -float 0;ok
 
 
###############################################################################
# Safari & WebKit
###############################################################################
 
running "Hiding Safariâ€™s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false;ok
 
running "Hiding Safariâ€™s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false;ok
 
running "Disabling Safariâ€™s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2;ok
 
running "Enabling Safariâ€™s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true;ok
 
running "Making Safariâ€™s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false;ok
 
running "Removing useless icons from Safariâ€™s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()";ok
 
running "Allow hitting the Backspace key to go to the previous page in history"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true;ok
 
running "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true;ok
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true;ok
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true;ok
 
running "Adding a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true;ok
 
 
###############################################################################
# Mail
###############################################################################
 
running "Setting email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false;ok
 
 
###############################################################################
# Terminal
###############################################################################
 
running "Enabling UTF-8 ONLY in Terminal.app and setting the Pro theme by default"
defaults write com.apple.terminal StringEncodings -array 4;ok
defaults write com.apple.Terminal "Default Window Settings" -string "Pro";ok
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro";ok
 
 
###############################################################################
# Time Machine
###############################################################################
 
running "Preventing Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true;ok
 
running "Disabling local Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disablelocal;ok
 
 
###############################################################################
# Messages                                                                    #
###############################################################################
 
running "Disable automatic emoji substitution (i.e. use plain text smileys)"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false;ok
 
running "Disable smart quotes as itâ€™s annoying for messages that contain code"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false;ok
 
running "Disable continuous spell checking"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false;ok
 
###############################################################################
# Personal Additions
###############################################################################
 
running "Disable hibernation (speeds up entering sleep mode)"
sudo pmset -a hibernatemode 0;ok
  
running "Disable the sudden motion sensor as itâ€™s not useful for SSDs"
sudo pmset -a sms 0;ok
 
running "Speeding up wake from sleep to 24 hours from an hour"
# http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
sudo pmset -a standbydelay 86400;ok
 
running "Show the battery percent"
defaults write com.apple.menuextra.battery ShowPercent -string "YES";ok
 
running "Disable annoying backswipe in Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false;ok

###############################################################################
# Transmission.app                                                            #
###############################################################################

running "Setting up an incomplete downloads folder in Downloads"
mkdir -p ~/Downloads/Incomplete;ok
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true;ok
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Incomplete";ok

running "Don't prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false;ok

running "Trash original torrent files"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true;ok

running "Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false;ok

running "Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false;ok

running "Setting Git to use Sublime Text as default editor"
git config --global core.editor "subl -n -w";ok


###############################################################################
# Kill affected applications
###############################################################################
 
running "Done!"
