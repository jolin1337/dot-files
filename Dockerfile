# CI for developement
#
# docker run -it \
#            -v ~/Documents/Projects:/root/Projects \
#            --name dotfiles \
#            dotfiles
#
FROM alpine:latest
FROM debian:sid-slim
WORKDIR "/"
RUN mkdir /root/Projects
WORKDIR /root/Projects
ENV DOTFILES=/root/.dotfiles
RUN apt-get update && apt-get install -y zsh git curl
# Install missing ripgrep recursive find
RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb && dpkg -i ripgrep_11.0.1_amd64.deb && rm ripgrep_11.0.1_amd64.deb
# Install missing Z tracking of files
RUN curl -L https://raw.githubusercontent.com/rupa/z/master/z.sh -o ~/.z
# Install missing diff-so-fancy git diff
RUN curl -L https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -o ~/.diff-so-fancy
# Install missing fzf file search tool
RUN git clone https://github.com/junegunn/fzf ~/.fzf && ~/.fzf/install --key-bindings --completion --no-update-rc
COPY . $DOTFILES
RUN cd $DOTFILES && DOTFILES=$DOTFILES && ./install.sh && cd -

CMD [ "zsh" ]
