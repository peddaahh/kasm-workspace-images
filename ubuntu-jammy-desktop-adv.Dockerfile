FROM ghcr.io/peddaahh/kasm-workspace-ubuntu-jammy-desktop:%VER%

USER root
RUN mkdir -p /home/kasm-user/Desktop
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

RUN echo "[Desktop Entry]" > /home/kasm-user/Desktop/PHPStorm.desktop
RUN echo "Type=Application" >> /home/kasm-user/Desktop/PHPStorm.desktop
RUN echo "Terminal=true" >> /home/kasm-user/Desktop/PHPStorm.desktop
RUN echo "Name=PHPStorm" >> /home/kasm-user/Desktop/PHPStorm.desktop
RUN echo "Icon=/opt/PhpStorm-232.10072.32/bin/phpstorm.svg" >> /home/kasm-user/Desktop/PHPStorm.desktop
RUN echo "Exec=/opt/PhpStorm-232.10072.32/bin/phpstorm.sh" >> /home/kasm-user/Desktop/PHPStorm.desktop

RUN wget https://download.jetbrains.com/python/pycharm-professional-2023.2.5.tar.gz
RUN sudo tar -xzf pycharm-professional-2023.2.5.tar.gz -C /opt
RUN chmod a+x /opt/pycharm-2023.2.5/bin/pycharm.sh
RUN echo "[Desktop Entry]" > /home/kasm-user/Desktop/PyCharm.desktop
RUN echo "Type=Application" >> /home/kasm-user/Desktop/PyCharm.desktop
RUN echo "Terminal=true" >> /home/kasm-user/Desktop/PyCharm.desktop
RUN echo "Name=PyCharm" >> /home/kasm-user/Desktop/PyCharm.desktop
RUN echo "Icon=/opt/pycharm-2023.2.5/bin/pycharm.svg" >> /home/kasm-user/Desktop/PyCharm.desktop
RUN echo "Exec=/opt/pycharm-2023.2.5/bin/pycharm.sh" >> /home/kasm-user/Desktop/PyCharm.desktop
