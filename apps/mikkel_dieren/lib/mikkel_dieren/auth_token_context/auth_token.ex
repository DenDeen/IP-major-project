defmodule MikkelDieren.AuthTokenContext.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias MikkelDieren.UserContext.User

  schema "auth_tokens" do
    field :token, :string
    field :name, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token, :name])
    |> validate_required([:token, :name])
  end

  @doc false
  def create_changeset(auth_token, attrs, user) do
    auth_token
    |> cast(attrs, [:token, :name])
    |> validate_required([:token, :name])
    |> put_assoc(:user, user)
  end
end
