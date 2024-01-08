defmodule TodolistWeb.AuthJSON do
  alias TodolistWeb.UserJSON

  def render(%{jwt: jwt, user: user}) do
    %{
      user: UserJSON.show(%{user: user}),
      token: jwt
    }
  end

  def render_error(%{message: message}) do
    %{message: message}
  end

end
