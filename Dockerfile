# Based on Marcelo Gonçalves <marcelocg@gmail.com> -> marcelocg/phoenix-docker
FROM ubuntu:latest
MAINTAINER tnarik <tnarik@lecafeautomatique.co.uk>

ENV PHOENIX_VERSION 1.1.4

RUN locale-gen en_US.UTF-8 && \
  update-locale LANG=en_US.UTF-8

# Elixir requires UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
  apt-get install -y sudo \
    curl \
    wget \
    git \
    make && \
  wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
  dpkg -i erlang-solutions_1.0_all.deb && \
  apt-get update && apt-get install -y elixir \
    erlang-dev \
    erlang-parsetools \
    inotify-tools \
    postgresql && \
  rm erlang-solutions_1.0_all.deb && \

  # Configure postgresql for use by Phoenix
  /etc/init.d/postgresql start && \
  sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';" && \
  /etc/init.d/postgresql stop && \

  rm -rf /var/lib/apt/lists/*

RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new-$PHOENIX_VERSION.ez && \
  mix local.hex --force && \
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && apt-get install -y nodejs && \

  rm -rf /var/lib/apt/lists/*

# Runtime folder
WORKDIR /code

# Runtime setup
COPY init.sh /init_elixir.sh
ENTRYPOINT ["/init_elixir.sh"]
CMD ["/bin/bash"]