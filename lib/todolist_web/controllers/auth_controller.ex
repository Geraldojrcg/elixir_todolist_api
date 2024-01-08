defmodule TodolistWeb.AuthController do
  use TodolistWeb, :controller

  alias TodolistWeb.Guardian
  alias Todolist.Accounts.Auth

  action_fallback TodolistWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    case Auth.find_user_and_check_password(%{"email" => email, "password" => password}) do
      {:ok, user} ->
        conn
        |> create_token(user)

      {:error, message} ->
        conn
        |> put_status(401)
        |> render(:show_error, message: message)
    end
  end

  def register(conn, %{"user" => user_params}) do
    with {:ok, user} <- Auth.register(user_params) do
      conn
      |> create_token(user)
    end
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:forbidden)
    |> json(%{"message" => "Not Authenticated"})
  end

  defp create_token(conn, user) do
    {:ok, token, _claims} =
          user |> Guardian.encode_and_sign
    conn
    |> put_status(:created)
    |> render(:render, jwt: token, user: user)
  end
end
