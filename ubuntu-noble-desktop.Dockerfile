FROM docker.io/kasmweb/ubuntu-noble-desktop:%VER%-rolling-weekly
ARG TARGETARCH

USER root

RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN apt update && apt install ca-certificates curl gnupg -y
RUN curl -sSL https://pkgs.netbird.io/debian/public.key | sudo gpg --dearmor --output /usr/share/keyrings/netbird-archive-keyring.gpg && echo 'deb [signed-by=/usr/share/keyrings/netbird-archive-keyring.gpg] https://pkgs.netbird.io/debian stable main' | sudo tee /etc/apt/sources.list.d/netbird.list
RUN apt update && apt install -y sudo dbus dbus-broker dnsutils iputils-ping jq wget build-essential python3 python3-pip jq wireguard wireguard-tools resolvconf jq libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin netbird
RUN echo "#1000 ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers


WORKDIR /tmp
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

RUN wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
RUN sudo apt install ./1password-latest.deb -y

RUN wget https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.8.0-Linux-x64.deb
RUN sudo apt install ./VNC-Viewer-7.8.0-Linux-x64.deb -y

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

RUN sed -i '/cmd sysctl -q/d' $(which wg-quick)
USER 1000
# install ZSH
RUN sh -c "$(curl -fsSL https://thmr.at/setup/zsh)"
RUN sudo usermod -s /bin/zsh kasm-user
WORKDIR /home/kasm-user
