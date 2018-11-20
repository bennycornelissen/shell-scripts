# Shell Scripts
Some shell scripts I've created for various things.

## About this repo
These scripts do all kinds of things; some small, some big. These scripts are a part of my daily personal workflow, and as such, they may or may not suit your needs. If you want to find out the reasoning behind a script, or need an example of how to use it, read ahead in the "About the scripts" section.

## How to use
I personally include this repo as a submodule in my dotfiles repo, set up to track the master branch. This way, whenever I pull the latest dotfiles changes on a system, I also have the most up-to-date version of the scripts. After that, all you need to do is update your `$PATH` and you're good to go.

## About the scripts

### cgit
The `cgit` script is basically 'Cluster Git', inspired by cssh. I use it to run `git` commands on multiple working copies. Say that you have all your repos checked out in `$HOME/code`. Instead of running `git pull --rebase` in 10 subdirectories, you can simply run it once in the parent dir:

```
$ cd ~/code
$ cgit pull --rebase --prune --autostash --recurse-submodules
## [blog]
Fetching submodule themes/cactus
Fetching submodule themes/minimal
Current branch master is up to date.


## [blog-infra]
Current branch master is up to date.

## [new-tool]
From .
 * branch            master     -> FETCH_HEAD
Current branch dockerfile-fixes is up to date.
```

**NOTE**: I also have a ton of tricks in my `.gitconfig` that you may want to check out at this point. You can find them on my [blog](https://blog.bennycornelissen.nl/post/favorite-git-tricks/)

### git-tree-backup
The `git-tree-backup` script is **not** a backup tool for the contents of working copies or git repositories. It is, however, a tool to backup a definition of what your 'git tree' looks like. If your repos are checked out in `$HOME/code` but you use multiple machines, it's practical to have all the same repos checked out on all machines, and have remotes configured in the same way. With `git-tree-backup`, you can create a list of all repos and their remote URLs for a given directory, and write that list to a file. If you write that list to a shared location that you can access from all your systems (cloud storage or network share), you can then use `git-tree-restore` to make sure your `$HOME/code` directory on comp;uter B is identical to computer A.

Example:

```
$ git-tree-backup /keybase/private/myuser/my-git-tree $HOME/code
$ cat /keybase/private/myuser/my-git-tree
blog ssh://git@git.example.com/myuser/blog.git
blog-infra git@github.com:myuser/blog-infra.git
shell-libs git@github.com:bennycornelissen/shell-libs.git
shell-scripts git@github.com:bennycornelissen/shell-scripts.git
```

### git-tree-restore
The `git-tree-restore` script is the counterpart of `git-tree-backup`. It takes the backup file and makes sure all defined repos are checked out in the given directory, and that their origins are configured correctly. It will check the configuration of existing repos, but it will **not** remove anything. I might add pruning functionality in the future.

Example:

```
$ cd ~/code
$ git-tree-restore /keybase/private/myuser/my-git-tree .
Nothing to do for blog
Nothing to do for blog-infra
Cloning shell-libs..
Setting URL for shell-scripts..
```

### link_ssh_agent
The `link_ssh_agent` script checks if you have an `$SSH_AUTH_SOCK` set, and creates/updates a symlink in a fixed location: `$HOME/.ssh/ssh-auth-sock`. This solves an issue where the SSH agent becomes unusable in a re-attached Tmux session. Read [this blog post](https://blog.bennycornelissen.nl/post/dotfile-magic-terminal-multiplexers-and-ssh-agents/) for a more elaborate explanation on the problem and how `link_ssh_agent` is part of the fix.

### ssh_knownhost_rm
This script allows one to quickly purge an entry from `$HOME/.ssh/known_hosts`. Whenever you encounter duplicate `known_hosts` entries when connecting to a machine, the error message usually contains the line number for the offending entry. You can remove it quickly like this:

```
$ ssh_knownhost_rm <line number>
```

Obviously, when there are multiple offending lines, you should remove them from the bottom up.

### ssh_load_key
I store my SSH private keys in `$HOME/.ssh`, but I'm too lazy to type `ssh-add ~/.ssh/<some key>` whenever I want to load a key into my agent. This tiny script fixes that. It takes the filename of the key, checks if it exists in `$HOME/.ssh/` and loads it.

```
$ ssh_load_key foobar
Key not found
$ ssh_load_key mykey
```
