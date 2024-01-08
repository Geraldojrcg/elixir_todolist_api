defmodule TodolistWeb.UserJSON do
  alias TodolistWeb.TodoJSON
  alias Todolist.Accounts.User

  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user, []))}
  end

  def show(%{user: user, todos: todos}) do
    data(user, todos)
  end

  defp data(%User{} = user, todos) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      todos: TodoJSON.index(%{todos: todos})
    }
  end
end
