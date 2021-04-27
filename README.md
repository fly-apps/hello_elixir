# HelloElixir!

This is an example project demonstrating how to deploy an Elixir and Phoenix application on Fly.io.

## Application Structure

This creates a basic Phoenix application that uses a PostgreSQL database. The Elixir deployment approach used here is building a release through Docker.

- [`Dockerfile`](./Dockerfile) - An Elixir release is built through Docker
- [`.dockerignore`](./.dockerignore) - Exclude pulling in Elixir deps and Node packages since they might have native compilation from your dev environment
- [`entrypoint.sh`](./entrypoint.sh) - Where Docker calls to start the application
- [`lib/hello_elixir/release.ex`](./lib/hello_elixir/release.ex) - Called by `entrypoint.sh` to run our database migrations
- [`config/runtime.exs`] - The runtime ENV values we expect for production

## Fly Configuration

- [`fly.toml`](.fly.toml) - Fly deployment configuration

### Secrets

Elixir has a mix task that can generate a new Phoenix key base secret. Let's use that.

```bash
mix phx.gen.secret
```

It generates a long string of random text. Let's store that as a secret for our app. When we run this command in our project folder, `flyctl` uses the `fly.toml` file to know which app we are setting the value on.

```
flyctl secrets set SECRET_KEY_BASE=<GENERATED>
```

### Postgres Database

```cmd
flyctl postgres create
```
```output
? App name: hello-elixir-db
Automatically selected personal organization: Mark Ericksen
? Select region: sea (Seattle, Washington (US))
? Select VM size: shared-cpu-1x - 256
? Volume size (GB): 10
Creating postgres cluster hello-elixir-db in organization personal
Postgres cluster hello-elixir-db created
  Username:    <USER>
  Password:    <PASSWORD>
  Hostname:    hello-elixir-db.internal
  Proxy Port:  5432
  PG Port: 5433
Save your credentials in a secure place, you won't be able to see them again!

Monitoring Deployment

2 desired, 2 placed, 2 healthy, 0 unhealthy [health checks: 6 total, 6 passing]
--> v0 deployed successfully

Connect to postgres
Any app within the personal organization can connect to postgres using the above credentials and the hostname "hello-elixir-db.internal."
For example: postgres://<USER>:<PASSWORD>@hello-elixir-db.internal:5432

See the postgres docs for more information on next steps, managing postgres, connecting from outside fly:  https://fly.io/docs/reference/postgres/
```

We can take the defaults which select the lowest values for CPU, size, etc. This is perfect for getting started.

### Attach our App to the Database

We can use `flyctl` to attach our app to the database which also sets our needed `DATABASE_URL` ENV value.

```cmd
flyctl postgres attach --postgres-app hello-elixir-db
```
```output
Postgres cluster hello-elixir-db is now attached to icy-leaf-7381
The following secret was added to icy-leaf-7381:
  DATABASE_URL=postgres://<NEW_USER>:<NEW_PASSWORD>@hello-elixir-db.internal:5432/icy_leaf_7381?sslmode=disable
```

We can see the secrets that Fly is using for our app like this.

```cmd
flyclt secrets list
```
```output
NAME            DIGEST                           DATE      
DATABASE_URL    830d8769ff33cba6c8b29d1cd6a6fbac 1m10s ago 
SECRET_KEY_BASE 84c992ac7ef334c21f2aaecd41c43666 9m20s ago
```

Looks like we're ready to deploy!

## Deploy

Once you've went through the steps of `flyctl launch`:

```
flyctl deploy
```

... will bring up your app!
