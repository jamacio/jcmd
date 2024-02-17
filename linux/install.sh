#!/bin/bash

cat << EOF > ~/jcmd
#!/bin/bash

add() {
    command_name=\$1
    command_value=\$2
    echo "\$command_name=\"\$command_value\"" >> ~/.jcmds/commands.conf
    echo "Command '\$command_name' added successfully!"
}

rm() {
    command_name=\$1
    grep -v "\$command_name=" ~/.jcmds/commands.conf > ~/.jcmds/commands.conf.tmp
    mv ~/.jcmds/commands.conf.tmp ~/.jcmds/commands.conf
    echo "Command '\$command_name' removed successfully!"
}

list() {
    echo "Available commands:"
    cat ~/.jcmds/commands.conf | cut -d'=' -f1
}

version() {
  echo "v0.0.1"
}

if [ ! -d "~/.jcmds" ]; then
    mkdir -p ~/.jcmds
fi

if [ ! -f "~/.jcmds/commands.conf" ]; then
    echo 'hello="echo '\''Hello World'\''"' > ~/.jcmds/commands.conf
fi

source ~/.jcmds/commands.conf

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

chmod +x ~/jcmd

echo "The 'jcmd' command has been successfully installed!"
