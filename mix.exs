defmodule Egaugex.Mixfile do
  use Mix.Project

  def project do
    [app: :egaugex,
     version: "0.1.0",
     description: "A simple egauge client to retrieve and parse data from egauge devices",
     package: package,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test, "coveralls.semaphore": :test],
     docs: [logo: "logo/brighterlink_logo.png",
            extras: ["README.md"]]
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
      {:httpoison, "~> 0.9.0"},
      {:floki, "~> 0.8"},
      {:http_digex, "~> 0.0.1"},
      {:excoveralls, "~> 0.5.4", only: :test},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: [
        "Samar Acharya",
        "Jonathan Hockman",
        "Bruce Wang"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Brightergy/egaugex"}
    ]
  end
end
