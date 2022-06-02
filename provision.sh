#!/bin/bash
cd ~

# node and nvm
if [ ! -d "${HOME}/.nvm" ]; then
	echo "Installing nvm"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash > /dev/null
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

if ! node -v | grep v16 > /dev/null; then
        nvm install v16 > /dev/null
fi

# python 3
if ! python3_loc="$(type -p python3)" || [[ -z $python3_loc ]]; then
	echo "Installing python3"
	sudo apt install software-properties-common -y > /dev/null
	sudo add-apt-repository ppa:deadsnakes/ppa > /dev/null
	sudo apt update > /dev/null
	sudo apt install python3.8 -y > /dev/null
fi

apt_plugins=(
        # "command package-name"
        "python2 python2"
        "tmux tmux"
        "mosh-server mosh"
        "nvim neovim"
)
for row in "${apt_plugins[@]}"; do
        split=($row)
        command="${split[0]}"
        package="${split[1]}"
        if ! command_loc="$(type -p $command)" || [[ -z $command_loc ]]; then
                echo "Installing $package"
                sudo apt install $package -y > /dev/null
        fi
done

# github cli
if ! gh_loc="$(type -p gh)" || [[ -z $gh_loc ]]; then
        echo "Installing github cli"
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update > /dev/null
        sudo apt install gh -y > /dev/null
fi

# docker
if ! docker_loc="$(type -p docker)" || [[ -z $docker_loc ]]; then
        echo "Installing docker"
        sudo apt update > /dev/null
        sudo apt install apt-transport-https ca-certificates curl software-properties-common -y > /dev/null
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - > /dev/null
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" > /dev/null
        sudo apt install docker-ce -y > /dev/null
fi

# docker compose
if [ ! -f ~/.docker/cli-plugins/docker-compose ]; then
        echo "Installing docker compose"
        mkdir -p ~/.docker/cli-plugins/ > /dev/null
        curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose > /dev/null
        chmod +x ~/.docker/cli-plugins/docker-compose > /dev/null
        sudo chown $USER /var/run/docker.sock > /dev/null
fi

# rustup
if ! rustup_loc="$(type -p rustup)" || [[ -z $rustup_loc ]]; then
        echo "Installing rust"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null
        source $HOME/.cargo/env
fi

# mosh ports
if ! sudo iptables --list | grep 60000:61000 > /dev/null; then
        echo "Opening UDP port range 60000:61000 for mosh"
        sudo iptables -I INPUT 1 -p udp --dport 60000:61000 -j ACCEPT
fi

# neovim config
if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
        echo "Installing vim-plug"
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' > /dev/null
fi

if [ -f "./configs/init.vim" ]; then
	rm -f ~/.config/nvim/init.vim > /dev/null
	mkdir -p ~/.config > /dev/null
	mkdir -p ~/.config/nvim > /dev/null
        cp ./configs/init.vim ~/.config/nvim/init.vim > /dev/null
fi

# nvim coc
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]; then
        echo '{"dependencies":{}}' > package.json
fi
coc_extensions=(
        coc-tsserver
        coc-rls
)
installed_coc_extensions=$(npm ls)
for extension in "${coc_extensions[@]}"; do
        if ! echo $installed_coc_extensions | grep $extension > /dev/null; then
                npm install $extension --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod > /dev/null
        fi
done

cd ~

# npm global installs
npm_packages=(
        neovim
        typescript
)
installed_npm_packages=$(npm ls -g)
for extension in "${npm_packages[@]}"; do
        if ! echo $installed_npm_packages | grep $package > /dev/null; then
                echo "Installing package $package via npm global"
                npm install -g $package > /dev/null
        fi
done

# code-server
if ! code_server_loc="$(type -p code-server)" || [[ -z $code_server_loc ]]; then
        echo "Installing code-server"
        curl -fsSL https://code-server.dev/install.sh | sh
fi

sudo systemctl enable --now code-server@$USER

extensions=(
        # vscodevim.vim doesnt work, using below temporarily
        9j.amvim
        esbenp.prettier-vscode
        shardulm94.trailing-spaces
        octref.vetur
        Equinusocio.vsc-community-material-theme
        bmewburn.vscode-intelephense-client
)
installed_vscode_extensions=$(code-server --list-extensions)
for extension in "${extensions[@]}"; do
        if ! echo $installed_vscode_extensions | grep $extension > /dev/null; then
                echo "Installing vscode extension $extension"
                code-server --install-extension $extension > /dev/null
        fi
done

# flutter
if ! flutter_loc="$(type -p flutter)" || [[ -z $flutter_loc ]]; then
        sudo snap install flutter --classic
fi

# increase filesystem watchers
if [ ! -f /etc/sysctl.d/10-user-watches.conf ]; then
        echo "fs.inotify.max_user_watches = 100000" > /etc/sysctl.d/10-user-watches.conf
        sudo sysctl -p
fi

# fish shell
if ! flutter_loc="$(type -p fish)" || [[ -z $flutter_loc ]]; then
        sudo apt-add-repository ppa:fish-shell/release-3 -y > /dev/null
        sudo apt update -y > /dev/null
        sudo apt install fish -y > /dev/null
fi
