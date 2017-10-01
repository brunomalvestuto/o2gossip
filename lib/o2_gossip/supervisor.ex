defmodule O2Gossip.Supervisor do
  @moduledoc false

  use Supervisor
  alias O2Gossip.Config
  alias O2Gossip.StationMonitor
  alias O2Gossip.Indicators

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Indicators, [Config.devices()]),
      worker(StationMonitor, [Config.interested_macs()])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
