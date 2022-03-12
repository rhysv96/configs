#!/bin/bash
cd ~

# node and nvm
if [ ! -d "${HOME}/.nvm" ]; then
	echo "Installing nvm"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash > /dev/null
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install v16 > /dev/null

# python 3
if ! python3_loc="$(type -p python3)" || [[ -z $python3_loc ]]; then
	echo "Installing python3"
	sudo apt install software-properties-common -y > /dev/null
	sudo add-apt-repository ppa:deadsnakes/ppa > /dev/null
	sudo apt update > /dev/null
	sudo apt install python3.8 -y > /dev/null
fi

# python 2
if ! python2_loc="$(type -p python2)" || [[ -z $python2_loc ]]; then
        echo "Installing python 2"
	sudo apt install python2 -y > /dev/null
fi

# tmux
if ! tmux_loc="$(type -p tmux)" || [[ -z $tmux_loc ]]; then
        echo "Installing tmux"
	sudo apt install tmux -y > /dev/null
fi

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
        mkdir -p ~/.docker/cli-plugins/ > /dev/null
        curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose > /dev/null
        chmod +x ~/.docker/cli-plugins/docker-compose > /dev/null
        sudo chown $USER /var/run/docker.sock > /dev/null
fi

# rustup
if ! rustup_loc="$(type -p rustup)" || [[ -z $rustup_loc ]]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source $HOME/.cargo/env
fi

# mosh
if ! mosh_loc="$(type -p mosh-server)" || [[ -z $mosh_loc ]]; then
        sudo apt install mosh -y >/dev/null
fi



# neovim and it's configurations
if ! nvim_loc="$(type -p nvim)" || [[ -z $nvim_loc ]]; then
        echo "Installing neovim"
	sudo apt install neovim -y > /dev/null
fi

if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
        echo "Installing vim-plug"
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' > /dev/null
fi

if [ -f "./configs/init.vim" ]; then
        echo "Transferring vim config"
	rm -f ~/.config/nvim/init.vim > /dev/null
	mkdir -p ~/.config > /dev/null
	mkdir -p ~/.config/nvim > /dev/null
        cp ./configs/init.vim ~/.config/nvim/init.vim > /dev/null
fi

# nvim coc
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
npm install coc-tsserver coc-rls --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod > /dev/null
cd ~
