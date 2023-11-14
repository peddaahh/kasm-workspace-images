FROM docker.io/kasmweb/ubuntu-jammy-desktop:1.14.0-rolling

USER root
RUN apt update && apt install sudo
RUN echo "#1000 ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

USER 1000
# install ZSH
RUN sh -c "$(curl -fsSL https://thmr.at/setup/zsh)"
RUN sudo usermod -s $(which zsh) kasm-user