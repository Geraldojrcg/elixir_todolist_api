defmodule TodolistWeb.TodoJSON do
  alias Todolist.Todos.Todo

  def index(%{todos: todos}) do
    %{data: for(todo <- todos, do: data(todo))}
  end

  def show(%{todo: todo}) do
    %{data: data(todo)}
  end

  defp data(%Todo{} = todo) do
    %{
      id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed,
      user_id: todo.user_id
    }
  end
end
