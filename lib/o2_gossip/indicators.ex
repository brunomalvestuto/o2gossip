defmodule O2Gossip.Indicators do
  alias ElixirALE.GPIO

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: __MODULE__])
  end

  def update(online) do
    GenServer.cast(__MODULE__, {:update, online})
  end

  def init(state) do
    state = state |> Enum.map(fn(device = %{"gpio" => pin}) ->
      {:ok, pid } = GPIO.start_link(pin, :output)
       GPIO.write(pid, true)
       device |> Map.put(:pid, pid) |> Map.put(:status, !true)
    end)

    {:ok, state}
  end

  def handle_cast({:update, online}, state) do
    {:noreply, set_indicators(state, online) }
  end

  defp set_indicators(indicators, online_people), do: Enum.map indicators, &(update_indicator(&1, Enum.member?(online_people, &1.name)))

  defp update_indicator(indicator = %{ :status => status }, new_status) when status == new_status, do: indicator
  defp update_indicator(indicator = %{:pid => pid, "owner" => name }, new_state = true) do
    log("#{name} just got home.")
    GPIO.write(pid, !new_state)
    %{ indicator | :status => new_state }
  end
  defp update_indicator(indicator = %{:pid => pid, "owner" => name }, new_state = false) do
    log("#{name} just left.")
    GPIO.write(pid, !new_state)
    %{ indicator | :status => new_state }
  end


  defp log(msg), do: File.write!("/home/pi/o2_gossip.log", "#{DateTime.utc_now}: #{msg}\n", [:append])
end
