defmodule O2Gossip.StationMonitor do
  use GenServer
  alias O2Gossip.Indicators
  alias O2Gossip.Config

  def start_link(interested_macs) do
    GenServer.start_link(__MODULE__, interested_macs, [name: __MODULE__])
  end

  def init(interested_macs) do
    schedule_work()
    {:ok, interested_macs}
  end

  def handle_info(:update, interested_macs) do
    online_mac_addresses = whos_online_from(interested_macs)
    IO.inspect online_mac_addresses
    #Indicators.update(online_mac_addresses)
    schedule_work()
    {:noreply, online_mac_addresses}
  end

  defp whos_online_from(interested_macs) do
   Config.airodump_csv
   |> File.stream!
   |> O2Gossip.APStations.stations
   |> O2Gossip.APStations.people_online(interested_macs, DateTime.utc_now, 30)
  end

  defp schedule_work() do
    Process.send_after(self(), :update, 2 * 1000)
  end
end
