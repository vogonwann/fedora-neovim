#!/bin/bash

echo "🚀 Starting Neovim Ultra AI + DOTNET + Vue + LazyGit + Netcoredbg setup 🚀"

# Update system
echo "➡️ Updating system packages"
sudo dnf upgrade --refresh -y

# Install Neovim + required system packages
echo "➡️ Installing Neovim and essential tools"
sudo dnf install -y neovim git curl gcc make ripgrep fd-find nodejs npm dotnet-sdk-9.0 unzip

# Install packer.nvim for plugin management
echo "➡️ Installing packer.nvim for Neovim"
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install global NPM packages (Volar for Vue LSP)
echo "➡️ Installing global NPM packages (Volar and others)"
sudo npm install -g @volar/vue-language-server typescript typescript-language-server

# Install dotnet LSP (csharp-ls)
echo "➡️ Installing dotnet csharp-ls"
dotnet tool install --global csharp-ls

# Ensure dotnet tools path is loaded
export PATH="$PATH:$HOME/.dotnet/tools"

if ! grep -q '.dotnet/tools' ~/.bashrc && ! grep -q '.dotnet/tools' ~/.zshrc; then
    echo "export PATH=\$PATH:\$HOME/.dotnet/tools" >> ~/.bashrc
    echo "export PATH=\$PATH:\$HOME/.dotnet/tools" >> ~/.zshrc
fi

# Install LazyGit
echo "➡️ Installing LazyGit"
if command -v lazygit &> /dev/null
then
    echo "✅ LazyGit already installed"
else
    if sudo dnf install -y lazygit; then
        echo "✅ LazyGit installed via dnf"
    else
        echo "❗️ dnf failed, downloading latest release from GitHub"
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo mv lazygit /usr/local/bin/
        rm lazygit.tar.gz
        echo "✅ LazyGit installed manually."
    fi
fi

# Install FiraCode Nerd Font (optional but nice)
echo "➡️ Installing FiraCode Nerd Font"
mkdir -p ~/.local/share/fonts
curl -Lo FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
unzip -o FiraCode.zip -d ~/.local/share/fonts
fc-cache -fv
rm FiraCode.zip

# Install Netcoredbg debugger
echo "➡️ Installing Netcoredbg (.NET debugger)"
mkdir -p ~/Downloads/netcoredbg
cd ~/Downloads/netcoredbg

NETCOREDBG_VERSION="2.2.0-900"
curl -L -o netcoredbg.tar.gz "https://github.com/Samsung/netcoredbg/releases/download/${NETCOREDBG_VERSION}/netcoredbg-linux-amd64.tar.gz"
tar -xzf netcoredbg.tar.gz

mkdir -p ~/.local/bin/netcoredbg
cp -r netcoredbg/* ~/.local/bin/netcoredbg

ln -sf ~/.local/bin/netcoredbg/netcoredbg ~/.local/bin/netcoredbg

cd ~
rm -rf ~/Downloads/netcoredbg

echo "✅ Netcoredbg installed to ~/.local/bin/netcoredbg"

# Setup Neovim config
echo "➡️ Setting up Neovim config..."
mkdir -p ~/.config/nvim
cp ./init.lua ~/.config/nvim/init.lua
echo "✅ Neovim config installed to ~/.config/nvim/init.lua"

echo ""
echo "🎉 DONE! Everything installed!"
echo "👉 Start Neovim and run :PackerSync to install plugins."
echo "👉 If PATH issues for dotnet tools → restart terminal or run 'source ~/.bashrc' or 'source ~/.zshrc'"
echo "👉 Happy hacking burke 🚀"

