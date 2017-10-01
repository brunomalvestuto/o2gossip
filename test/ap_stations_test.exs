defmodule O2Gossip.APStationsTest do
  use ExUnit.Case

  import O2Gossip.APStations, only: [stations: 1, people_online: 4 ]

  test "given a csv it returns a list of APS" do
    stations_list = "./home.csv" |>
                      Path.expand(__DIR__) |>
                      File.stream! |> stations

    assert stations_list == [[{"Station MAC", "00:00:00:00:00:00"}, {"Probed ESSIDs", ""}, {"Power", "-58"}, {"Last time seen", "2017-09-01 09:18:12"}, {"First time seen", "2017-09-01 09:17:02"}, {"BSSID", "00:00:00:00:00:00"}, {"# packets", "316"}]]

  end

  test 'given a list of stations, a map list { interested_mac_address, name }, time reference and a threshold in secounds, works out a list of people that have last been seen are in threshold' do

    {:ok, time_reference, _} = DateTime.from_iso8601("2017-09-01T09:19:12Z")
    actual = [
      %{"Station MAC" => "00:00:00:00:00:00", "Last time seen" => "2017-09-01 09:18:12", "Test" => "XPTO"},
      %{"Station MAC" => "10:00:00:00:00:00", "Last time seen" => "2017-09-01 09:18:12"},
      %{"Station MAC" => "20:00:00:00:00:00", "Last time seen" => "2017-09-01 09:18:12"},
      %{"Station MAC" => "30:00:00:00:00:00", "Last time seen" => "2017-09-01 09:17:12"},
    ] |> people_online(%{"00:00:00:00:00:00" => "Bob", "10:00:00:00:00:00" => "Alice", "30:00:00:00:00:00" => "Luke"}, time_reference , 60)

    assert actual == ["Bob", "Alice"]
  end
end
