defmodule Todolist.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.Users` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some_email#{System.unique_integer([:positive])}@mail.com"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        name: "some name",
        password: "some password"
      })
      |> Todolist.Accounts.Users.create_user()

    user
  end
end
