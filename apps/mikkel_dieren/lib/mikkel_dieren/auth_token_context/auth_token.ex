defmodule MikkelDieren.AuthTokenContext.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias MikkelDieren.UserContext.User

  schema "auth_tokens" do
    field :token, :string
    field :name, :string
    field :is_writable, :boolean, default: true
    belongs_to :user, User
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token, :name, :is_writable])
    |> validate_required([:token, :name])
  end

  @doc false
  def create_changeset(auth_token, attrs, user) do
    auth_token
    |> cast(attrs, [:token, :name, :is_writable])
    |> validate_required([:token, :name])
    |> put_assoc(:user, user)
  end
end
