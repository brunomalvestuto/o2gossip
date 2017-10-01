defmodule O2Gossip.APStations do
  def stations(file_stream) do
    file_stream = file_stream |> Stream.drop(5)

    header = file_stream
             |> Enum.take(1)
             |> Enum.at(0)
             |> String.trim
             |> String.split(", ")

    file_stream |> Stream.drop(1)
                |> Stream.reject(fn(el) -> el == "\n"  end)
                |>Enum.reduce([], fn(el, acc)->
                  it = el |> String.trim
                          |> String.split(",")
                          |> Enum.map(fn(el) -> String.trim(el) end)
                  [ it | acc ]
                end)
                |> Enum.map(&(Enum.zip(header, &1)
                |> Enum.into(Map.new)
                |> Enum.reverse))
                |> Enum.map( fn(e) -> Enum.into(e, %{}) end )

  end

  def people_online(stations, mac_to_person, time_reference, threshold) do
    stations |> Enum.filter(fn(%{"Station MAC" => mac_address}) ->
      Map.has_key?(mac_to_person, mac_address)
    end)
    |> Enum.filter(fn(%{"Last time seen" => last_seen}) ->

      last_seen = Regex.replace ~r/^(.*?) (.*?)$/,  last_seen, "\\1T\\2Z"
      {:ok, last_seen, _ } = DateTime.from_iso8601(last_seen)
      DateTime.diff(time_reference, last_seen ) <= threshold
    end)
    |> Enum.map(fn(%{"Station MAC" => mac_address}) -> Map.fetch!(mac_to_person, mac_address) end)
  end
end
