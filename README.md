# jcmd

This repository contains the `jcmd` script, a command-line tool that allows you to add, remove, and execute custom commands.

## Installation and Update

### Installation & Update Script

To **install** or **update** jcmd, you should run the install script. To do that, you may either download and run the script manually, or use the following cURL or Wget command:

```sh
curl -o- https://raw.githubusercontent.com/jamacio/jcmd/v0.0.1/linux/install.sh | bash
```

```sh
wget -qO- https://raw.githubusercontent.com/jamacio/jcmd/v0.0.1/linux/install.sh | bash
```

### Usage

## Here are some examples of how to use jcmd:

Add a new command

```
jcmd add "my_command" "echo Hello, world!; date"
```

Execute a command

```
jcmd my_command
```

Remove a command

```
jcmd rm my_command
```

List all commands

```
jcmd
```

```
jcmd list
```

Check the version of jcmd

```
jcmd version
```

## How it Works

jcmd works by maintaining a configuration file that stores all your custom commands. When you add a command, it is added to this file. Similarly, when you remove a command, it is removed from this file. When you execute a command, jcmd looks in this file for the command and, if found, executes it.

## License

This project is licensed under the terms of the MIT license.

See [LICENSE.md](./LICENSE.md).
