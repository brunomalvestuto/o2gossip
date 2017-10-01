defmodule O2Gossip do
  @moduledoc """
  Documentation for O2Gossip.
  """

  @doc """
  Start

  ## Examples

      iex> O2Gossip.start
      :world

  """
  def start do
    O2Gossip.Supervisor.start_link
  end
end
