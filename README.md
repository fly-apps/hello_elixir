# HelloElixir!

This is an example app demonstrating how to deploy an Elixir with Phoenix program on Fly.io.

## Application Structure

This creates a basic Phoenix application that uses a PostgreSQL database. The Elixir deployment approach is to use releases and Docker.

- [`Dockerfile`](./Dockerfile) - An Elixir release is built through Docker
- [`entrypoint.sh`](./entrypoint.sh) - Where Docker calls to start the application
- [`lib/hello_elixir/release.ex`](./lib/hello_elixir/release.ex) - Called by `entrypoint.sh` to run our database migrations
- [`config/runtime.exs`] - The runtime ENV values we expect for production

## Fly Configuration

- [`fly.toml`](.fly.toml) - Fly deployment configuration

## Docker

An easy way to build an Elixir release and run an Elixir application on Fly.

- [`.dockerignore`](./.dockerignore) - Exclude pulling in Elixir deps and Node packages since they might have native compilation from your dev environment

## Deploy

Once you've went through the steps of `flyctl launch`:

```
flyctl deploy
```

... will bring up your app!
