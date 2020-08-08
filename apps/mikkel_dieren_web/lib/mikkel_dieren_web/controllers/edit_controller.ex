defmodule MikkelDierenWeb.EditController do
    use MikkelDierenWeb, :controller
  
    alias MikkelDieren.UserContext
    alias MikkelDieren.UserContext.User
    alias MikkelDieren.AuthTokenContext
    alias MikkelDieren.AuthTokenContext.AuthToken
  
    def index(conn, %{"id" => id}) do
      user = UserContext.get_user!(id)
      changeset = AuthTokenContext.change_auth_token(%AuthToken{})
      tokens = AuthTokenContext.load_auth_tokens(id)
      render(conn, "index.html", changeset: changeset, tokens: tokens, user: user)
    end

    def new(conn, _params) do
      changeset = UserContext.change_user(%User{})
      render(conn, "new.html", changeset: changeset)
    end
  
    def create(conn, %{"user" => user_params}) do
      case UserContext.create_user(user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "The account was created successfully. Now it is time to log in!")
          |> redirect(to: "/login")
  
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  
    def edit_username(conn, %{"id" => id}) do
      user = UserContext.get_user!(id)
      changeset = UserContext.change_user(user)
      roles = UserContext.get_acceptable_roles()
      render(conn, "edit_username.html", user: user, changeset: changeset)
    end

    def edit_password(conn, %{"id" => id}) do
        user = UserContext.get_user!(id)
        changeset = UserContext.change_user(user)
        roles = UserContext.get_acceptable_roles()
        render(conn, "edit_password.html", user: user, changeset: changeset)
    end
  
    def update_username(conn, %{"id" => id, "user" => username}) do
        user = UserContext.get_user!(id)
    
        case UserContext.update_username(user, username) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User updated successfully.")
            |> redirect(to: Routes.edit_path(conn, :index, user))
    
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit_username.html", user: user, changeset: changeset)
        end
    end

    def update_password(conn, %{"id" => id, "user" => attrs}) do
        user = UserContext.get_user!(id)
        case UserContext.update_password(user, attrs["current_password"], attrs) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "Password updated successfully.")
            |> redirect(to: Routes.edit_path(conn, :index, user))
    
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit_password.html", user: user, changeset: changeset)
          
          {:error, reason} ->
            conn
            |> put_flash(:error, "Information given wasn't correct.")
            |> redirect(to: Routes.edit_path(conn, :index, user))
      end
    end

    def generate_api_token(conn, %{"id" => id, "auth_token" => key}) do
      user = UserContext.get_user!(id)
      token = AuthTokenContext.generate_token(id)
      case AuthTokenContext.create_auth_token(%{user_id: id, name: key["key"], token: token, is_writable: key["is_writable"]}, user) do
        {:ok, auth_token} ->
          conn
          |> put_flash(:info, "Token created successfully.")
          |> redirect(to: Routes.edit_path(conn, :index, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "index.html", auth_token: token, changeset: changeset)  
      end        
    end
  end
  