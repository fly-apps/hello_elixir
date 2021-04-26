# To determine the Alpine release being used:
#
#   - Look at the Dockerfile dependencies and follow it back to the base until
#     reaching the actual alpine version.
#     - https://hub.docker.com/_/elixir
#  
#   - cat /etc/alpine-release
#
# Debugging Notes:
#
#   docker run -it --rm hello_elixir /bin/ash

FROM elixir:1.11-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV as prod
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey

# Copy over the mix.exs and mix.lock files to load the dependencies. If those
# files don't change, then we don't keep re-fetching and rebuilding the deps.
COPY mix.exs ./
COPY mix.lock ./
COPY config ./config

RUN mix deps.get --only prod && \
    mix deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

# If using TailwindCSS, there is a special "purge" step and that requires the
# code to see what is being used. So pull the project source in here.
COPY . .
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
RUN mix release

# prepare release docker image
FROM alpine:3.13 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/hello_elixir ./

ADD entrypoint.sh ./

ENV HOME=/app
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey
ENV PORT=4000
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["bin/hello_elixir", "start"]
