FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV SSH_PUB_KEY=""

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    sudo \
    bash \
    curl \
    wget \
    apache2 \
    git \
    gitweb \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=git
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG HOME_DIR=/var/lib/git
ARG SHELL_PATH=/usr/sbin/nologin

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID --home-dir $HOME_DIR --create-home --shell $SHELL_PATH $USERNAME && \
    mkdir -p $HOME_DIR/.ssh && \
    echo "$SSH_PUB_KEY" > $HOME_DIR/.ssh/authorized_keys && \
    chmod 700 $HOME_DIR/.ssh && \
    chmod 600 $HOME_DIR/.ssh/authorized_keys && \
    chown -R $USER_UID:$USER_GID $HOME_DIR && \
    mkdir -p /var/run/sshd

COPY gitweb.conf /etc/apache2/sites-available/gitweb.conf
RUN echo '$projectroot = "/var/lib/git";' > /etc/gitweb.conf

RUN a2enmod cgi alias rewrite && \
    a2dissite 000-default.conf && \
    a2ensite gitweb.conf

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80/tcp 22/tcp

VOLUME ["/var/lib/git"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]