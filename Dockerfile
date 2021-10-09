FROM rockylinux/rockylinux as build
SHELL ["/bin/bash", "-c"]
ENV MIX_ENV prod
ENV LANG en_US.UTF-8

# Set the right versions
ENV ERLANG_VERSION latest
ENV ELIXIR_VERSION latest

# System dependencies
RUN dnf update -y && \
  dnf group install "Development tools" -y && \
  dnf install -y git openssl-devel ncurses-devel && \
  dnf install -y nodejs && \
  dnf clean all

# ASDF
RUN git clone https://github.com/asdf-vm/asdf.git /root/.asdf --branch v0.8.1 && \
  echo "source /root/.asdf/asdf.sh" >> /root/.bashrc

# Erlang & Elixir
RUN source /root/.bashrc && \
  asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git && \
  asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git && \
  asdf install erlang $ERLANG_VERSION && \
  asdf install elixir $ELIXIR_VERSION && \
  asdf global erlang $ERLANG_VERSION && \
  asdf global elixir $ELIXIR_VERSION

# esbuild
RUN npm install --global esbuild

# Build tools
RUN source /root/.bashrc && \
  mix local.rebar --force && \
  mix local.hex -if-missing --force

RUN mkdir /myapp
COPY ./ /myapp
WORKDIR /myapp

RUN source /root/.bashrc && \
  mix deps.get --only prod  && \
  mix compile  && \
  mix assets.deploy  && \
  mix release --overwrite

RUN tar -zcf /myapp/release.tar.gz -C /myapp/_build/prod/rel/my_app .

RUN echo "#!/usr/bin/bash" >> /copy.sh
RUN echo "/usr/bin/cp -r /myapp/_build/prod/rel/my_app /releases" >> /copy.sh
RUN chmod +x /copy.sh
#COPY --from=build /myapp/_build/prod/rel ./releases

# sudo docker build . --output type=local,dest=./releases

#This is now possible since Docker 19.03.0 in July 2019 introduced "custom build outputs". See the official docs about custom build outputs.

# COPY 
# sudo docker run -v /home/strzibny/elixir/my_app/releases:/releases 868b1d003243 /usr/bin/cp -r /myapp/_build/prod/rel/my_app /releases
# sudo docker run -v /home/strzibny/elixir/my_app/releases:/releases 75bc7eb371f8 /usr/bin/cp -r /myapp/release.tar.gz /releases

# sudo docker run -v /home/strzibny/elixir/my_app/releases:/releases 6289e5ac5a42 /copy.sh
# sudo docker run -v /home/strzibny/elixir/my_app/releases:/releases 6289e5ac5a42 /copy.sh


# using docker cp // running container

# docker cp -r 30aa69da7514:/myapp/_build/prod/rel/my_app /home/strzibny/elixir/releases|-