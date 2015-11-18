defmodule ToDoServer.Mixfile do
  use Mix.Project

  def project do
    [app: :todo_server,
     version: "0.0.1",
     elixir: "~> 1.0.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :cowboy, :reactive_entity, :sockjs],
     mod: {ToDoServer, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      { :reactive_observer, github: "ReactiveObserver/reactiveobserver-elixir" },
      { :reactive_api, github: "ReactiveWeb/reactive_api" },
      { :reactive_entity, github: "ReactiveWeb/reactive_entity"},
      { :reactive_db, github: "ReactiveWeb/reactive_db"}
    ]
  end
end
