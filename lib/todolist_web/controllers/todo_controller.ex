defmodule TodolistWeb.TodoController do
  use TodolistWeb, :controller

  alias Todolist.Todos.Todo
  alias Todolist.Todos.Todos

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    todos = Todos.list_todos()
    render(conn, :index, todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    user = Guardian.Plug.current_resource(conn)
    with {:ok, %Todo{} = todo} <- Todos.create_todo(Map.merge(todo_params, %{"user_id" => user.id})) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/todos/#{todo}")
      |> render(:show, todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    render(conn, :show, todo: todo)
  end

  def update(%Plug.Conn{body_params: %{"todo" => todo_params}} = conn, %{"id" => id, "todo" => todo_params}) do
    todo = Todos.get_todo!(id)

    with {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
      render(conn, :show, todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)

    with {:ok, %Todo{}} <- Todos.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
