defmodule ToDoServer do
  use Application

  def start_http() do
    dispatch = :cowboy_router.compile([
      {:_, [
        {"/", :cowboy_static, {:file, "../todo_client/index.html"}},
        ReactiveObserver.sockjs_handler("/sockjs/",Todo.Api),
        {"/[...]", :cowboy_static, {:dir, "../todo_client"}}
      ]}
    ])
    :cowboy.start_http(:my_http_listener, 100, [port: 8880],
      [
        {:env, [{:dispatch, dispatch}]},
        {:onresponse, &spa_404_hook/4}
      ])
  end

  def spa_404_hook(404, headers, <<>>, req) do
    body = <<"">>
    headers2 = :lists.keyreplace("content-length", 1, headers,
      {"content-length", :erlang.integer_to_list(:erlang.byte_size(body))})
      {"/" <> path, _ } = :cowboy_req.path(req)
    headers3 = [{"Location", "/#!" <> path} |headers2]
    {:ok,req2}=:cowboy_req.reply(302, headers3, body, req)
    req2
  end
  def spa_404_hook(_, _, _, req) do
    req
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(ToDoServer.Worker, [arg1, arg2, arg3])
    ]

    start_http()

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ToDoServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
