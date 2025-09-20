#!/bin/bash

echo "Uninstalling jcmd..."

# Remove the main executable
echo "Removing main executable..."
sudo rm -f /usr/local/bin/jcmd

# Remove the completion script
echo "Removing completion script..."
sudo rm -f /etc/bash_completion.d/jcmd

# Remove user data (commands and configuration)
echo "Removing user data..."
rm -rf ~/.jcmds

# Remove completion loading from .bashrc (if added)
echo "Cleaning up .bashrc..."
if [ -f ~/.bashrc ]; then
    sed -i '/# Load jcmd completion/,+3d' ~/.bashrc
fi

echo ""
echo "jcmd has been completely removed from your system!"
echo ""
echo "Please run 'source ~/.bashrc' or open a new terminal to complete the removal."