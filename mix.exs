defmodule Egaugex.Mixfile do
  use Mix.Project

  def project do
    [app: :egaugex,
     version: "0.0.1",
     description: "A simple egauge parser to retrieve and parse data from egauge devices",
     package: package,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.8.0"},
      {:floki, "~> 0.8"},
      {:excoveralls, github: "parroty/excoveralls", only: :test}
    ]
  end

  defp package do
    [
      maintainers: [
        "Samar Acharya",
        "Jonathan Hockman",
        "Bruce Wang"
      ],
      licenses: ["MIT"]
    ]
  end
end
