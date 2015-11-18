defmodule Todo.Api do
  use Reactive.Api
  require Logger

  allow Todo.List,
    observation: [:tasks],
    request: [:add_task,:remove_task,:task_done,:task_undone]
  
end