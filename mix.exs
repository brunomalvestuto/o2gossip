defmodule O2Gossip.Mixfile do
  use Mix.Project

  def project do
    [
      app: :o2_gossip,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_ale, git: "https://github.com/fhunleth/elixir_ale.git"}
    ]
  end
end
