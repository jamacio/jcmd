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

generate_completions() {
    local current_word previous_word
    COMPREPLY=()
    current_word="\${COMP_WORDS[COMP_CWORD]}"
    previous_word="\${COMP_WORDS[COMP_CWORD-1]}"

    if [[ \$previous_word == "jcmd" ]] ; then
        local commands=\$(cat \$HOME/.jcmds/commands.conf | cut -d'=' -f1)
        COMPREPLY=( \$(compgen -W "\$commands" -- \$current_word) )
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

complete -F generate_completions jcmd
EOF'

sudo chmod +x /usr/local/bin/jcmd

echo "The 'jcmd' command has been successfully installed!"

# Add the completion script to bash_completion.d
sudo sh -c 'cat << EOF > /etc/bash_completion.d/jcmd
#!/bin/bash

generate_completions() {
    local current_word previous_word
    COMPREPLY=()
    current_word="\${COMP_WORDS[COMP_CWORD]}"
    previous_word="\${COMP_WORDS[COMP_CWORD-1]}"

    if [[ \$previous_word == "jcmd" ]] ; then
        local commands=\$(cat \$HOME/.jcmds/commands.conf | cut -d'=' -f1)
        COMPREPLY=( \$(compgen -W "\$commands" -- \$current_word) )
    fi
}

complete -F generate_completions jcmd
EOF'

# Source the new completion script
source /etc/bash_completion.d/jcmd

jcmd
