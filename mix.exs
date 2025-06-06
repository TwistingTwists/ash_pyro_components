defmodule AshPyroComponents.MixProject do
  @moduledoc false
  use Mix.Project

  @source_url "https://github.com/frankdugan3/ash_pyro_components"
  @version "0.1.0"
  @description """
  Automatically render UI for Ash resources via DSL configuration.
  """
  def project do
    [
      app: :ash_pyro_components,
      version: @version,
      description: @description,
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs(),
      test_paths: ["lib"],
      name: "AshPyroComponents",
      source_url: @source_url,
      elixirc_paths: ["lib"],
      aliases: aliases(),
      compilers: [:yecc] ++ Mix.compilers(),
      dialyzer: [plt_add_apps: [:ash, :spark, :ecto, :mix]]
    ]
  end

  defp extras do
    "documentation/**/*.md"
    |> Path.wildcard()
    |> Enum.map(fn path ->
      title =
        path
        |> Path.basename(".md")
        |> String.split(~r/[-_]/)
        |> Enum.map_join(" ", &String.capitalize/1)

      {String.to_atom(path),
       [
         title: title,
         default: title == "Get Started"
       ]}
    end)
  end

  defp groups_for_extras do
    [
      Tutorials: [
        "documentation/tutorials/get-started.md",
        ~r'documentation/tutorials'
      ]
    ]
  end

  defp docs do
    [
      main: "about",
      source_ref: "v#{@version}",
      output: "doc",
      source_url: @source_url,
      extra_section: "GUIDES",
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      groups_for_modules: groups_for_modules(),
      groups_for_functions: [
        Components: &(&1[:type] == :component),
        Macros: &(&1[:type] == :macro)
      ]
    ]
  end

  defp package do
    [
      name: :ash_pyro_components,
      maintainers: ["Frank Dugan III"],
      licenses: ["MIT"],
      links: %{GitHub: @source_url},
      files:
        ~w(assets lib documentation) ++
          ~w(README* CHANGELOG* LICENSE* mix.exs package.json .formatter.exs)
    ]
  end

  defp groups_for_modules do
    [
      Core: [
        AshPyroComponents
      ],
      Overrides: [
        AshPyroComponents.Overrides,
        ~r/\.Overrides\./
      ],
      Components: [~r/\.Components\./],
      "Component Tooling": [
        AshPyroComponents.Component,
        AshPyroComponents.LiveComponent,
        AshPyroComponents.LiveView
      ],
      Types: [~r/\.Type\./]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Code quality tooling
      {:credo, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, ">= 0.0.0", only: :dev, runtime: false},
      {:doctor, ">= 0.0.0", only: :dev, runtime: false},
      {:ex_check, "~> 0.15", [env: :prod, hex: "ex_check", only: :dev, runtime: false, repo: "hexpm"]},
      {:faker, "~> 0.17", only: [:test, :dev]},
      {:floki, ">= 0.30.0", only: :test},
      {:mix_audit, ">= 0.0.0", only: :dev, runtime: false},
      {:styler, "~> 0.11", only: [:dev, :test], runtime: false},
      # Build tooling
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:git_ops, "~> 2.6", only: :dev},
      # Core dependencies
      # {:pyro, "~> 0.3"},
      {:pyro, github: "TwistingTwists/pyro", branch: "main"},
      # {:ash_pyro, "~> 0.2"},
      # {:pyro_components, "~> 0.1"},
      {:pyro_components, github: "TwistingTwists/pyro_components", branch: "main"},
      {:ash_pyro, github: "frankdugan3/ash_pyro", branch: "main"},
      # {:pyro_components, path: "../pyro_components"},
      # {:ash_pyro, path: "../ash_pyro"},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix, "~> 1.7"},
      {:ash, "~> 3.0"},
      {:ash_phoenix, "~> 2.0"},
      {:gettext, "~> 0.24", optional: true}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "compile", "docs"],
      build: ["format", "compile", "docs"],
      # until we hit 1.0, we will ensure no major release!
      release: ["git_ops.release --no-major"],
      publish: ["hex.publish"]
    ]
  end
end
