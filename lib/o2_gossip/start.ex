defmodule Mix.Tasks.Start do
  use Mix.Task

  @shortdoc "Start parsing and switching the lights"

  def run(_) do
    :application.start(:yamerl)
    O2Gossip.start
  end
end

