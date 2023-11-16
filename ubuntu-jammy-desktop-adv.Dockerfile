FROM ghcr.io/peddaahh/kasm-workspace-ubuntu-jammy-desktop:%VER%

RUN curl https://raw.githubusercontent.com/apache/flink/02d30ace69dc18555a5085eccf70ee884e73a16e/tools/azure-pipelines/free_disk_space.sh | bash
RUN wget https://download.jetbrains.com/webide/PhpStorm-2023.2.3.tar.gz
RUN sudo tar -xzf PhpStorm-2023.2.3.tar.gz -C /opt
RUN chmod +x /opt/PhpStorm-232.10072.32/bin/phpstorm.sh
