FROM debian:latest

# Set the shell to bash
SHELL ["/bin/bash", "-c"]

# Make sure all is up to date
RUN apt update && apt upgrade -y

# Install neovim and build libraries for autocompletion
RUN apt-get install -y neovim git curl python3-pip python3 \
                       build-essential cmake zsh fonts-powerline \
                       zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev libbz2-dev 
                       # default-jre default-jdk

# Install Python 3.8
WORKDIR /python3.8
RUN curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz
RUN tar -xf Python-3.8.2.tar.xz
RUN cd Python-3.8.2 && \
    ./configure --enable-optimizations && \
    make -j 4 && \
    # 4== 4 cores in my processor
    make altinstall

# Setup Golang
WORKDIR /tmp
RUN curl -O https://dl.google.com/go/go1.13.8.linux-amd64.tar.gz
RUN tar xvf go1.13.8.linux-amd64.tar.gz
RUN mv go /usr/local


# Setup nodejs (for autocompletion)
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs

# Get the neovim python plugin
RUN pip3 install pynvim

# Create a user to setup for developing
RUN useradd -ms /bin/bash dev
USER dev
WORKDIR /home/dev
RUN tail -n +9 /home/dev/.bashrc > /home/dev/.bashrc
RUN echo >> /home/dev/.bashrc
RUN echo 'export GOPATH=$HOME/work' >> /home/dev/.bashrc
RUN echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /home/dev/.bashrc

# Setup Oh-my-Zhs
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY --chown=dev:dev ./docker-environments/base/oh-my-zsh.sh oh-my-zsh.sh
RUN cp /home/dev/oh-my-zsh.sh .zshrc
WORKDIR /home/dev/.oh-my-zsh/custom/plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions

# Setup vim
RUN mkdir -p /home/dev/.config/nvim/bundle
COPY --chown=dev:dev ./docker-environments/base/vimrc /home/dev/.config/nvim/init.vim

# Install vundle and all plugins
RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/dev/.config/nvim/bundle/Vundle.vim
RUN bash -c 'echo | echo | vim +PluginInstall +qall &>/dev/null'

# Install YCM
WORKDIR /home/dev/.vim/bundle/YouCompleteMe
RUN /bin/bash -c '. /home/dev/.bashrc; python3 install.py --clang-completer --go-completer --ts-completer'

# Add a default YCM semantic completion for C config
WORKDIR /home/dev
COPY --chown=dev:dev ./docker-environments/base/default_ycm_extra_conf.py /home/dev/.ycm_extra_conf.py

# Install Prettier
WORKDIR /home/dev/.vim/bundle/vim-prettier
RUN npm install

USER root
# Finally install commonly used libraries for auto-complete
RUN pip3 install requests pwntools

# Change to the workspace directory
WORKDIR /home/dev/workspace


RUN apt-get install -y cscope tmux

# Setup SSH server
RUN apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/*
# ENTRYPOINT [ "service", "ssh", "start"]
RUN mkdir /var/run/sshd
RUN echo 'root:THEPASSWORDYOUCREATED' | chpasswd
RUN echo 'dev:THEPASSWORDYOUCREATED' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN usermod -a -G root dev
RUN update-rc.d ssh defaults
#CMD ["/usr/sbin/sshd", "-D"]

# Install FZF
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/dev/.fzf
RUN /home/dev/.fzf/install

# Install Docker and Docker-Compose
RUN apt-get install \
                apt-transport-https \
                ca-certificates \
                #software-properties-common \
                gnupg-agent
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN echo \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" >> /etc/apt/sources.list && apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io
RUN mkdir -p /home/dev/.config/nvim/plugin
RUN curl http://cscope.sourceforge.net/cscope_maps.vim > /home/dev/.config/nvim/plugin/cscope_maps.vim
RUN curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose



RUN usermod -aG sudo dev
RUN echo "dev  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Fix locales
RUN apt-get install -y locales && locale-gen en_US.UTF-8
RUN echo "Europe/Stockholm" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8


USER dev
RUN cp /home/dev/oh-my-zsh.sh /home/dev/.zshrc
