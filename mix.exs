defmodule Protocols.MixProject do
  use Mix.Project

  def project do
    [
      app: :protocols,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:poison, "~> 5.0"},
      {:jtd, "~> 0.1"},
      {:avrora, "~> 0.21"}
    ]
  end
end
