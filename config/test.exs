use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :a_demo, MikkelDieren.Repo,
  username: System.get_env("TEST_DB_USER") || "root",
  password: System.get_env("TEST_DB_PASSWORD") || "t",
  database: System.get_env("TEST_DB_NAME") || "Local instance MySQL80",
  hostname: System.get_env("TEST_DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: (System.get_env("DB_POOL_SIZE") || "10") |> Integer.parse() |> elem(0)

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mikkel_dieren_web, MikkelDierenWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
