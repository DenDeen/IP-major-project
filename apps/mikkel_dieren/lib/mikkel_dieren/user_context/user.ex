defmodule MikkelDieren.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias MikkelDieren.AnimalContext.Animal

  @acceptable_roles ["Admin", "User"]

  schema "users" do
    field :username, :string, unique: true
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :hashed_password, :string
    field :role, :string, default: "User"
    field :date_of_birth, :date
    has_many :animals, Animal
    has_many :auth_tokens, MikkelDieren.AuthTokenContext.AuthToken
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :password_confirmation, :role, :first_name, :last_name, :date_of_birth, :role])
    |> validate_required([:username, :password, :role, :first_name, :last_name, :date_of_birth])
    |> validate_inclusion(:role, @acceptable_roles)
    |> validate_confirmation(:password,
      message: 
        "Passwords do not match."
    )
    |> unique_constraint(:username, name: :users_username_index,
      message:
        "Wow that's coincidence! " <>
        "Another person already has this username." <>
        "Oh gosh, our system can't deal with this. " <>
        "Please pick another username please. :) "
    )
    |> put_password_hash()
  end

  @doc false
  def changeusername(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username,
      message: "Username already taken." 
    )
  end

  @doc false
  def changepassword(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, hashed_password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
