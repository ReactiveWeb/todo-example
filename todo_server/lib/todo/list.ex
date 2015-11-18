defmodule Todo.List do
  use Reactive.Entity
  require Logger

  def init(_args) do
    { :ok, %{ # STATE:
      tasks: []
    },%{ # OPTIONS:
    }}
  end

  def get(:tasks,state) do
    {:reply, state.tasks, state}
  end

  def request({:api_request,[:add_task,task_name],_context},state,_from,_request_id) do
    task = %{
      name: task_name,
      done: false
    }
    tasks = [task | state.tasks]
    notify_observers(:tasks,{:unshift,[task]})
    save_me()
    {:reply, :ok, %{ state | tasks: tasks } }
  end
  def request({:api_request,[:remove_task,task_name],_context},state,_from,_request_id) do
    tasks = state.tasks |> Enum.filter(fn(task) -> task.name != task_name end)
    notify_observers(:tasks,{:removeBy,[:name,task_name]})
    save_me()
    {:reply, :ok, %{ state | tasks: tasks } }
  end
  def request({:api_request,[:task_done,task_name],_context},state,_from,_request_id) do
    tasks = for task <- state.tasks do
      if(task.name == task_name) do
        %{task | done: true}
      else
        task
      end
    end
    save_me()
    notify_observers(:tasks,{:updateFieldBy,[:name,task_name,:done,true]})
    {:reply, :ok, %{ state | tasks: tasks } }
  end
  def request({:api_request,[:task_undone,task_name],_context},state,_from,_request_id) do
    tasks = for task <- state.tasks do
      if(task.name == task_name) do
        %{task | done: false}
      else
        task
      end
    end
    save_me()
    notify_observers(:tasks,{:updateFieldBy,[:name,task_name,:done,false]})
    {:reply, :ok, %{ state | tasks: tasks } }
  end
  
end