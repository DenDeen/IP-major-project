defmodule MikkelDieren.AuthTokenContextTest do
  use MikkelDieren.DataCase

  alias MikkelDieren.AuthTokenContext

  describe "auth_tokens" do
    alias MikkelDieren.AuthTokenContext.AuthToken

    @valid_attrs %{revoked: true, revoked_at: "2010-04-17T14:00:00Z", token: "some token"}
    @update_attrs %{revoked: false, revoked_at: "2011-05-18T15:01:01Z", token: "some updated token"}
    @invalid_attrs %{revoked: nil, revoked_at: nil, token: nil}

    def auth_token_fixture(attrs \\ %{}) do
      {:ok, auth_token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AuthTokenContext.create_auth_token()

      auth_token
    end

    test "list_auth_tokens/0 returns all auth_tokens" do
      auth_token = auth_token_fixture()
      assert AuthTokenContext.list_auth_tokens() == [auth_token]
    end

    test "get_auth_token!/1 returns the auth_token with given id" do
      auth_token = auth_token_fixture()
      assert AuthTokenContext.get_auth_token!(auth_token.id) == auth_token
    end

    test "create_auth_token/1 with valid data creates a auth_token" do
      assert {:ok, %AuthToken{} = auth_token} = AuthTokenContext.create_auth_token(@valid_attrs)
      assert auth_token.revoked == true
      assert auth_token.revoked_at == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert auth_token.token == "some token"
    end

    test "create_auth_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AuthTokenContext.create_auth_token(@invalid_attrs)
    end

    test "update_auth_token/2 with valid data updates the auth_token" do
      auth_token = auth_token_fixture()
      assert {:ok, %AuthToken{} = auth_token} = AuthTokenContext.update_auth_token(auth_token, @update_attrs)
      assert auth_token.revoked == false
      assert auth_token.revoked_at == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert auth_token.token == "some updated token"
    end

    test "update_auth_token/2 with invalid data returns error changeset" do
      auth_token = auth_token_fixture()
      assert {:error, %Ecto.Changeset{}} = AuthTokenContext.update_auth_token(auth_token, @invalid_attrs)
      assert auth_token == AuthTokenContext.get_auth_token!(auth_token.id)
    end

    test "delete_auth_token/1 deletes the auth_token" do
      auth_token = auth_token_fixture()
      assert {:ok, %AuthToken{}} = AuthTokenContext.delete_auth_token(auth_token)
      assert_raise Ecto.NoResultsError, fn -> AuthTokenContext.get_auth_token!(auth_token.id) end
    end

    test "change_auth_token/1 returns a auth_token changeset" do
      auth_token = auth_token_fixture()
      assert %Ecto.Changeset{} = AuthTokenContext.change_auth_token(auth_token)
    end
  end
end
