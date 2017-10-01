defmodule O2Gossip.Config do
  def airodump_csv do
    case Application.get_env(:o2_gossip, :airodump_csv) do
      {:system, var} -> System.get_env(var)
      file -> file
    end
  end

  def devices do
    File.cwd! |> Path.join("config/devices.yml") |> YamlElixir.read_from_file |> Map.fetch!("devices")
  end

  def interested_macs do
    Enum.map devices(), &(Map.fetch!(&1, "mac"))
  end
end
