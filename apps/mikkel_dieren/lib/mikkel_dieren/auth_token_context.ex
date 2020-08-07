defmodule MikkelDieren.AuthTokenContext do
  @moduledoc """
  The AuthTokenContext context.
  """

  import Ecto.Query, warn: false
  import Plug.Conn

  alias MikkelDieren.Repo
  alias MikkelDieren.AuthTokenContext.AuthToken
  alias MikkelDieren.UserContext.User
  

  @seed "user token"
  @secret "sXHcq40Ok5HYyamDIjTOnRf1gUWMYM"

  def generate_token(id) do
    Phoenix.Token.sign(@secret, @seed, id, max_age: 86400)
  end

  def verify_token(token) do
    case Phoenix.Token.verify(@secret, @seed, token, max_age: 86400) do
      {:ok, id} -> {:ok, token}
      error -> error
    end
  end

  def verify_token(token, key) do
    case Phoenix.Token.verify(@secret, key, token, max_age: 86400) do
      {:ok, id} -> {:ok, token}
      error -> error
    end
  end

  def get_auth_token(conn) do
    (conn.params["bearer"] || conn.cookies["bearer"])
      |> verify_token
  end

  def get_auth_token_header(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [token] -> 
        verify_token(token)

      error -> 
    end
  end

  @doc """
  Returns the list of auth_tokens.

  ## Examples

      iex> list_auth_tokens()
      [%AuthToken{}, ...]

  """
  def list_auth_tokens do
    Repo.all(AuthToken)
  end

  def load_auth_tokens(id) do
    query = from(AuthToken, where: [user_id: ^id], select: [:id, :name])
    query |> Repo.all
  end

  @doc """
  Gets a single auth_token.

  Raises `Ecto.NoResultsError` if the Auth token does not exist.

  ## Examples

      iex> get_auth_token!(123)
      %AuthToken{}

      iex> get_auth_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_auth_token!(id), do: Repo.get!(AuthToken, id)

  @doc """
  Creates a auth_token.

  ## Examples

      iex> create_auth_token(%{field: value})
      {:ok, %AuthToken{}}

      iex> create_auth_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_auth_token(attrs \\ %{}, %User{} = user) do
    %AuthToken{}
    |> AuthToken.create_changeset(attrs, user)
    |> Repo.insert()
  end

  @doc """
  Updates a auth_token.

  ## Examples

      iex> update_auth_token(auth_token, %{field: new_value})
      {:ok, %AuthToken{}}

      iex> update_auth_token(auth_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_auth_token(%AuthToken{} = auth_token, attrs) do
    auth_token
    |> AuthToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a auth_token.

  ## Examples

      iex> delete_auth_token(auth_token)
      {:ok, %AuthToken{}}

      iex> delete_auth_token(auth_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_auth_token(%AuthToken{} = auth_token) do
    Repo.delete(auth_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking auth_token changes.

  ## Examples

      iex> change_auth_token(auth_token)
      %Ecto.Changeset{data: %AuthToken{}}

  """
  def change_auth_token(%AuthToken{} = auth_token, attrs \\ %{}) do
    AuthToken.changeset(auth_token, attrs)
  end
end
