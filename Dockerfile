FROM hexpm/elixir:1.11.2-erlang-23.1.4-alpine-3.12.1 as build

# install build dependencies
RUN apk add --no-cache --update git build-base nodejs yarn

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# build assets
COPY assets assets
RUN cd assets && yarn install && yarn run webpack --mode production
RUN mix phx.digest

# build project
COPY priv priv
COPY lib lib
RUN mix compile

# build release
COPY rel rel
RUN mix release

# prepare release image
FROM alpine:3.12.0 AS app
RUN apk add --no-cache --update bash openssl

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/phoenix_example ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

CMD ["/app/bin/phoenix_example", "start"]
