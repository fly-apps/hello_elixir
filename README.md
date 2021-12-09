# HelloElixir!

This is an example project demonstrating how to deploy an Elixir and Phoenix application on Fly.io.

## Application Structure

This is a basic Phoenix application backed by a PostgreSQL database. The Elixir deployment is handled by building a release with Docker.

- [`Dockerfile`](./Dockerfile) - An Elixir release is built through Docker
- [`.dockerignore`](./.dockerignore) - Exclude pulling in Elixir deps and Node packages since they might have native compilation from your dev environment
- [`lib/hello_elixir/release.ex`](./lib/hello_elixir/release.ex) - Executed during deploy from `fly.toml` to run our database migrations
- [`config/runtime.exs`](./config/runtime.exs) - The runtime ENV values we expect for production

## Fly Configuration

- [`fly.toml`](./fly.toml) - Fly deployment configuration

This file will be updated through the launch process.
## Launch the app on Fly

Run `fly launch`. It will walk you through the steps to get the app running. Launch will take care of setting `SECRET_KEY_BASE` and booting
a Postgres database.

Then you can open the example app with `fly open`.

Also try:

* `fly secrets list`
* `fly status`
* `fly postgres list`

## Deployment

From this point on, you can make changes and deploy with `fly deploy --remote-only`.
