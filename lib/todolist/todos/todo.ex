defmodule Todolist.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  alias Todolist.Accounts.User

  schema "todos" do
    field :description, :string
    field :title, :string
    field :completed, :boolean, default: false

    timestamps(type: :utc_datetime)

    belongs_to :user, User
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :completed, :user_id])
    |> validate_required([:title, :description])
    |> validate_length(:title, min: 1, max: 40)
    |> validate_length(:description, min: 1)
  end
end
