#!/bin/bash

sudo sh -c 'cat << EOF > /usr/local/bin/jcmd
#!/bin/bash

add() {
    command_name=\$1
    shift
    command_value="\$@"
    echo "\$command_name=\"\$command_value\"" >> \$HOME/.jcmds/commands.conf
    echo "Command '\$command_name' added successfully!"
}

rm() {
    command_name=\$1
    grep -v "\$command_name=" \$HOME/.jcmds/commands.conf > \$HOME/.jcmds/commands.conf.tmp
    mv \$HOME/.jcmds/commands.conf.tmp \$HOME/.jcmds/commands.conf
}

list() {
    echo "Available commands:"
    cat \$HOME/.jcmds/commands.conf | cut -d'=' -f1
}

version() {
  echo "v0.0.1"
}

makedir() {
    if [ ! -d "\$HOME/.jcmds" ]; then
        mkdir -p \$HOME/.jcmds
    fi

    if [ ! -f "\$HOME/.jcmds/commands.conf" ]; then
        printf "hello=\"echo Hello, World!\"\n" > \$HOME/.jcmds/commands.conf
    fi
}

makedir

source \$HOME/.jcmds/commands.conf

command=\$1
if [ "\$command" = "" ]; then
    list
elif [ "\$command" = "add" ]; then
    rm \$2
    add \$2 \$3
elif [ "\$command" = "rm" ]; then
    rm \$2
    echo "Command '\$command_name' removed successfully!"
elif [ "\$command" = "list" ]; then
   list
elif [ "\$command" = "version" ]; then
   version
elif [ -z "\${!command}" ]; then
    echo "Unknown command: \$command"
    list
else
    eval \${!command}
fi
EOF'

sudo chmod +x /usr/local/bin/jcmd

echo "The 'jcmd' command has been successfully installed!"

# Add the completion script to bash_completion.d
sudo tee /etc/bash_completion.d/jcmd > /dev/null << 'EOF'
#!/bin/bash

_jcmd_completion() {
    local current_word previous_word commands
    COMPREPLY=()
    current_word="${COMP_WORDS[COMP_CWORD]}"
    previous_word="${COMP_WORDS[COMP_CWORD-1]}"

    # Check if user has .jcmds directory and commands.conf
    if [ ! -d "$HOME/.jcmds" ] || [ ! -f "$HOME/.jcmds/commands.conf" ]; then
        return 0
    fi

    # If we are completing the first argument after jcmd
    if [[ $COMP_CWORD -eq 1 ]]; then
        # Get all commands from the config file, plus built-in commands
        local custom_commands=$(cat "$HOME/.jcmds/commands.conf" 2>/dev/null | cut -d'=' -f1 | tr '\n' ' ')
        local builtin_commands="add rm list version"
        commands="$custom_commands $builtin_commands"
        
        COMPREPLY=( $(compgen -W "$commands" -- "$current_word") )
        return 0
    fi

    # If previous word is "add" or "rm", complete with existing custom commands
    if [[ "$previous_word" == "add" ]] || [[ "$previous_word" == "rm" ]]; then
        local custom_commands=$(cat "$HOME/.jcmds/commands.conf" 2>/dev/null | cut -d'=' -f1 | tr '\n' ' ')
        COMPREPLY=( $(compgen -W "$custom_commands" -- "$current_word") )
        return 0
    fi

    return 0
}

complete -F _jcmd_completion jcmd
EOF

# Source the new completion script
if [ -f /etc/bash_completion.d/jcmd ]; then
    source /etc/bash_completion.d/jcmd
fi

# Also try to source it for the current user
if [ -f ~/.bashrc ]; then
    # Add sourcing to .bashrc if not already present
    if ! grep -q "source /etc/bash_completion.d/jcmd" ~/.bashrc 2>/dev/null; then
        echo "# Load jcmd completion" >> ~/.bashrc
        echo "if [ -f /etc/bash_completion.d/jcmd ]; then" >> ~/.bashrc
        echo "    source /etc/bash_completion.d/jcmd" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
fi

# Reload the current shell to activate completion
source ~/.bashrc 2>/dev/null || true
source /etc/bash_completion.d/jcmd 2>/dev/null || true

echo "jcmd installed successfully!"
echo ""
echo "Usage examples:"
echo "  jcmd add mycommand \"echo Hello World\""
echo "  jcmd mycommand"
echo "  jcmd list"
echo "  jcmd rm mycommand"

jcmd
