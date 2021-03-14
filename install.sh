# neovim installation
brew install neovim \
        fzf \
        the_silver_searcher \
        ripgrep \
        python3

npm install --global neovim

python3 -m pip install neovim --user

# powerlines fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
