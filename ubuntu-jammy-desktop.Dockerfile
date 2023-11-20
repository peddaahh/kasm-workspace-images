FROM docker.io/kasmweb/ubuntu-jammy-desktop:%VER%-rolling

USER root
RUN sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

RUN apt update && curl https://raw.githubusercontent.com/apache/flink/02d30ace69dc18555a5085eccf70ee884e73a16e/tools/azure-pipelines/free_disk_space.sh | bash && apt install -y sudo curl jq wget build-essential python3 python3-pip wireguard openresolv brave-browser libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin php8.1 php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath php8.1-sqlite3
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN echo "#1000 ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# https://hub.docker.com/r/rustlang/rust/dockerfile
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    USER=root \
    PATH=/usr/local/cargo/bin:$PATH

# install rust
RUN set -eux; \
    \
    url="https://sh.rustup.rs"; \
    wget "$url" -O rustup-init; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

RUN echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/00-local-userns.conf
RUN service procps restart

RUN wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
RUN sudo apt install ./1password-latest.deb -y

RUN curl https://raw.githubusercontent.com/apache/flink/02d30ace69dc18555a5085eccf70ee884e73a16e/tools/azure-pipelines/free_disk_space.sh | bash
RUN wget https://download.jetbrains.com/webide/PhpStorm-2023.2.3.tar.gz
RUN sudo tar -xzf PhpStorm-2023.2.3.tar.gz -C /opt
RUN chmod a+x /opt/PhpStorm-232.10072.32/bin/phpstorm.sh
RUN sudo chown root /opt/PhpStorm-232.10072.32/jbr/lib/chrome-sandbox
RUN sudo chmod 4755 /opt/PhpStorm-232.10072.32/jbr/lib/chrome-sandbox

RUN echo "[Desktop Entry]" > /home/kasm-default-profile/Desktop/PHPStorm.desktop
RUN echo "Type=Application" >> /home/kasm-default-profile/Desktop/PHPStorm.desktop
RUN echo "Terminal=true" >> /home/kasm-default-profile/Desktop/PHPStorm.desktop
RUN echo "Name=PHPStorm" >> /home/kasm-default-profile/Desktop/PHPStorm.desktop
RUN echo "Icon=/opt/PhpStorm-232.10072.32/bin/phpstorm.svg" >> /home/kasm-default-profile/Desktop/PHPStorm.desktop
RUN echo "Exec=/opt/PhpStorm-232.10072.32/bin/phpstorm.sh" >> /home/kasm-default-profile/Desktop/PHPStorm.desktop

RUN wget https://download.jetbrains.com/python/pycharm-professional-2023.2.5.tar.gz
RUN sudo tar -xzf pycharm-professional-2023.2.5.tar.gz -C /opt
RUN chmod a+x /opt/pycharm-2023.2.5/bin/pycharm.sh
RUN echo "[Desktop Entry]" > /home/kasm-default-profile/Desktop/PyCharm.desktop
RUN echo "Type=Application" >> /home/kasm-default-profile/Desktop/PyCharm.desktop
RUN echo "Terminal=true" >> /home/kasm-default-profile/Desktop/PyCharm.desktop
RUN echo "Name=PyCharm" >> /home/kasm-default-profile/Desktop/PyCharm.desktop
RUN echo "Icon=/opt/pycharm-2023.2.5/bin/pycharm.svg" >> /home/kasm-default-profile/Desktop/PyCharm.desktop
RUN echo "Exec=/opt/pycharm-2023.2.5/bin/pycharm.sh" >> /home/kasm-default-profile/Desktop/PyCharm.desktop

USER 1000
# install ZSH
RUN sh -c "$(curl -fsSL https://thmr.at/setup/zsh)"
RUN sudo usermod -s /bin/zsh kasm-user
