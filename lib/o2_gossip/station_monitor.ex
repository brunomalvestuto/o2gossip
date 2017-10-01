defmodule O2Gossip.StationMonitor do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state = {file, mac_addresses, notify}) do
    notify.(whos_online(file, mac_addresses))
    schedule_work()
    {:ok, state}
  end

  def handle_info(:update, state = {file, mac_addresses, notify}) do
    notify.(whos_online(file, mac_addresses))
    schedule_work()
    {:noreply, state}
  end

  defp whos_online(file, mac_addresses) do
   file
   |> File.stream!
   |> O2Gossip.APStations.stations
   |> O2Gossip.APStations.people_online(mac_addresses, DateTime.utc_now, 30)
  end

  defp schedule_work(), do: Process.send_after(self(), :update, 2 * 1000)
end
