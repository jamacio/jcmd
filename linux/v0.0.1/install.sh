#!/bin/bash

cat << EOF > /usr/local/bin/jcmd
#!/bin/bash

add() {
    command_name=\$1
    command_value=\$2
    echo "\$command_name=\"\$command_value\"" >> \$HOME/.jcmds/commands.conf
    echo "Command '\$command_name' added successfully!"
}

rm() {
    command_name=\$1
    grep -v "\$command_name=" \$HOME/.jcmds/commands.conf > \$HOME/.jcmds/commands.conf.tmp
    mv \$HOME/.jcmds/commands.conf.tmp \$HOME/.jcmds/commands.conf
    echo "Command '\$command_name' removed successfully!"
}

list() {
    echo "Available commands:"
    cat \$HOME/.jcmds/commands.conf | cut -d'=' -f1
}

version() {
  echo "v0.0.1"
}

if [ ! -d "\$HOME/.jcmds" ]; then
    mkdir -p \$HOME/.jcmds
fi

if [ ! -f "\$HOME/.jcmds/commands.conf" ]; then
    echo 'hello="echo '\''Hello World'\''"' > \$HOME/.jcmds/commands.conf
fi

source \$HOME/.jcmds/commands.conf

command=\$1
if [ "\$command" = "" ]; then
    list
elif [ "\$command" = "add" ]; then
    add \$2 \$3
elif [ "\$command" = "rm" ]; then
    rm \$2
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
EOF

chmod +x /usr/local/bin/jcmd

echo "The 'jcmd' command has been successfully installed!"
