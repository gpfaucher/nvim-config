# Install LSP servers with Yay
yay -Syu lua-language-server marksman

# Install LSP servers with NPM
npm i -g bash-language-server

yay -Syu dotnet-sdk-7.0 dotnet-runtime-7.0 apsnet-runtime-7.0
# Install .NET LSP
dotnet tool install --global csharp-ls
dotnet tool install --global csharpier
