# HelloElixir!

This is an example project demonstrating how to deploy an Elixir and Phoenix application on Fly.io.

This was created using `mix phx.new hello_elixir` with the following versions:

- erlang - 26.2.2
- elixir - 1.16.1-otp-26
- phoenix - 1.7.11

## Deploy steps

Install [`flyctl`](https://fly.io/docs/hands-on/install-flyctl/), the command line interface we use for controlling our application.

With the `fly` command available, we launch!

```
fly launch
```

Output:
```
Scanning source code
Resolving Hex dependencies...
Resolution completed in 0.114s
Unchanged:
  bandit 1.2.3
  ...
  websock_adapter 0.5.5
All dependencies are up to date
Detected a Phoenix app
Creating app in /home/user/hello_elixir
We're about to launch your Phoenix app on Fly.io. Here's what you're getting:

Organization: Your Name                 (fly launch defaults to the personal org)
Name:         hello-elixir              (derived from your directory name)
Region:       San Jose, California (US) (this is the fastest region for you)
App Machines: shared-cpu-1x, 1GB RAM    (most apps need about 1GB of RAM)
Postgres:     <none>                    (not requested)
Redis:        <none>                    (not requested)

? Do you want to tweak these settings before proceeding? Yes
Opening https://fly.io/cli/launch/d0ec26d8b93c3ce8efe94855b1ea ...
```

If you want a Postgres database, answer "yes" to tweak the settings. You'll be taken to a webpage where you can change the selections.

After the process completes, your app is launched!

## Clustering

A recently generated Phoenix app already includes [`dns_cluster`](https://github.com/phoenixframework/dns_cluster) in the project! That means we'll already be clustering when we deploy multiple instances.

By default, the Erlang COOKIE is uniquely generated for each new build. This still allows for clustering, but we can explicitly set it to make it allow some other neat abilities.

You can read more about that in [Clustering: The Cookie Situation](https://fly.io/docs/elixir/the-basics/clustering/#the-cookie-situation).
https://fly.io/docs/elixir/the-basics/clustering/#adding-dns_cluster

In our `fly.toml` file, we'll add and ENV setting for the cookie value we want to use. It looks like this:

```toml
[env]
  RELEASE_COOKIE = "my-app-cookie"
```

Run `fly deploy` after setting this ENV to make it take effect.

## Observer

Elixir and Erlang have a built-in tool called Observer that let's us explore a running system. You can read more about that in [Connecting Observer to Your App in Production](https://fly.io/docs/elixir/advanced-guides/connect-observer-to-your-app/).

## Deploying

Once you've gone through the steps of `fly launch`:

```
fly deploy
```

... will deploy your changes!

To open your app in a browser:

```
fly apps open
```

To access your Fly.io dashboard:

```
fly dashboard
```

To access your logs locally:

```
fly logs
```

## Digging deeper

### Dockerfile

Where did the Dockerfile come from?

The `fly launch` process detects our Phoenix application and runs [`mix phx.gen.release`](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Release.html#module-docker) to generate the release files and a Dockerfile, which can be further customized for the project as needed.

### `fly.toml`

The `fly launch` command generates the `fly.toml` file for us. That includes the following command:

```toml
[deploy]
  release_command = '/app/bin/migrate'
```

This runs our migrations before starting the app on a deploy.

You can check out the `fly.example.toml` file as a reference.