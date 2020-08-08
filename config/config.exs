# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :mikkel_dieren,
  ecto_repos: [MikkelDieren.Repo]

config :mikkel_dieren_web,
  ecto_repos: [MikkelDieren.Repo],
  generators: [context_app: :mikkel_dieren]

config :mikkel_dieren, MikkelDieren.AuthTokenContext,
  seed: "user token",
  secret: "sXHcq40Ok5HYyamDIjTOnRf1gUWMYM"

# Configures the endpoint
config :mikkel_dieren_web, MikkelDierenWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WdTcfA/SiWy00b3xyOyJSUE8GaGVu2LDMQHVWvyZ54jCPKRCdRtY5slguk6ZGM7Q",
  render_errors: [view: MikkelDierenWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MikkelDieren.PubSub,
  live_view: [signing_salt: "da7igvJH"]

config :mikkel_dieren_web, MikkelDierenWeb.Guardian,
  issuer: "mikkel_dieren_web",
  secret_key: "Mm4/MgwxFY9LvRRztGYrwx7xbRD2iaZwHSdv+eGE+schObERUNcLB5KaXURLAYIP" # paste input here

config :mikkel_dieren, MikkelDierenWeb.Gettext,
  locales: ~w(en nl), # ja stands for Japanese.
  default_locale: "en"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :junit_formatter,
  report_file: "report_file.xml",
  # this is imported in your app! hence the double ..
  report_dir: "../../test-reports",
  print_report_file: true,
  prepend_project_name?: true