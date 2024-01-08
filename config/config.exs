# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :todolist,
  ecto_repos: [Todolist.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :todolist, TodolistWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: TodolistWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Todolist.PubSub,
  live_view: [signing_salt: "s9bi3RpC"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :todolist, Todolist.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :todolist, TodolistWeb.Guardian,
       issuer: "todolist",
       secret_key: "egWw0b7PNSvdBJBEQu3s1KIFIZHMeAAXEfR23UFlQx8G2pQqwDnhJvlg2TFTLYVn"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
