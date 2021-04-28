#!/bin/sh

# Run migrations before startup
/app/bin/hello_elixir eval "HelloElixir.Release.migrate"

exec $@