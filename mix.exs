defmodule Dakiya.MixProject do
  use Mix.Project

  def project do
    [
      app: :dakiya,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: Cli]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Dakiya, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.3"},
      {:plug, "~> 1.6"},
      {:cowboy, "~> 2.4"},
    ]
  end
end
