defmodule HelloElixir.ObanBusiness do
  use Oban.Worker, queue: :events
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id} = _args}) do
    # Wait 1 second before logging
    Process.sleep(1_000)
    Logger.info("Ran oban job #{inspect(id)}!")

    :ok
  end
end
