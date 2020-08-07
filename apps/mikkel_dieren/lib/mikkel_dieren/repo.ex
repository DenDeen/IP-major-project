defmodule MikkelDieren.Repo do
  use Ecto.Repo,
    otp_app: :mikkel_dieren,
    adapter: Ecto.Adapters.MyXQL
end
