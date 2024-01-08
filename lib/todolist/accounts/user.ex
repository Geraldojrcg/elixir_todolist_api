defmodule Todolist.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Todolist.Todos.Todo

  schema "users" do
    field :name, :string
    field :password, :string
    field :email, :string

    timestamps(type: :utc_datetime)

    has_many :todos, Todo
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+\-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/)
    |> unique_constraint(:email)
  end
end
