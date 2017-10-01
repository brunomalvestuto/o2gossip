alias ElixirALE.GPIO

defmodule O2Gossip.Indicators do
  use GenServer

  def start_link(pins) do
    state = pins |> Enum.map(fn({name,pin}) ->
      with {:ok, pid } = GPIO.start_link(pin, :output),
           GPIO.write(pid, true), do:  %{ :pid => pid, :name => name, :status => !true }
    end)

    GenServer.start_link(__MODULE__, state)
  end

  def update(pid, people_online), do: GenServer.cast( pid, {:update, people_online})

  def handle_cast({:update, online_people}, state) do
    {:noreply, set_indicators(state, online_people) }
  end

  def set_indicators(indicators, online_people) do
    Enum.map indicators, &(update_indicator(&1, Enum.member?(online_people, &1.name)))
  end

  defp update_indicator(indicator = %{ :status => status }, new_status) when status == new_status, do: indicator

  defp update_indicator(indicator = %{:pid => pid, :name => name }, new_state = true) do
    log("#{name} just got home.")
    GPIO.write(pid, !new_state)
    %{ indicator | :status => new_state }
  end

  defp update_indicator(indicator = %{:pid => pid, :name => name }, new_state = false) do
    log("#{name} just left.")
    GPIO.write(pid, !new_state)
    %{ indicator | :status => new_state }
  end


  def log(msg), do: File.write!("/home/pi/o2_gossip.log", "#{DateTime.utc_now}: #{msg}\n", [:append])
end
