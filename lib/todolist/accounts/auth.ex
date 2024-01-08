defmodule Todolist.Accounts.Auth do
  import Ecto.{Query, Changeset}, warn: false

  alias Todolist.Repo
  alias Todolist.Accounts.User
  alias Todolist.Accounts.Encryption

  def find_user_and_check_password(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> {:error, "Invalid username or password"}
    end
  end

  @spec register(
          :invalid
          | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: any()
  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> hash_password
    |> Repo.insert()
  end

  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Encryption.validate_password(password, user.password)
    end
  end

  def hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Encryption.password_hashing(pass))
      _ ->
        changeset
    end
  end
end
