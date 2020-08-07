defmodule MikkelDierenWeb.SessionController do
    use MikkelDierenWeb, :controller
  
    alias MikkelDierenWeb.Guardian
    alias MikkelDieren.UserContext
    alias MikkelDieren.UserContext.User
    alias MikkelDieren.AuthTokenContext
    alias MikkelDieren.AuthTokenContext.AuthToken
    alias MikkelDieren.Repo
  
    def new(conn, _) do
      changeset = UserContext.change_user(%User{})
      maybe_user = Guardian.Plug.current_resource(conn)
  
      if maybe_user do
        redirect(conn, to: "/user_scope")
      else
        render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
      end
    end
  
    def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
      UserContext.authenticate_user(username, password)
      |> login_reply(conn)
    end
  
    def logout(conn, _) do
      case AuthTokenContext.get_auth_token(conn) do
        {:ok, token} ->
          case Repo.get_by(AuthToken, %{token: token}) do
            nil -> {:error, :not_found}
            auth_token -> Repo.delete(auth_token)
          end
        error -> error
      end
      conn
      |> Guardian.Plug.sign_out()
      |> redirect(to: "/login")
    end
  
    defp login_reply({:ok, user}, conn) do
      token = AuthTokenContext.generate_token(user.id)
      Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token, name: "user token"}))
      conn
      |> put_resp_cookie("bearer", token, max_age: 365 * 24 * 60 * 60)
      |> put_flash(:info, "Welcome back!")
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: "/user_scope")
    end
  
    defp login_reply({:error, reason}, conn) do
      conn
      |> put_flash(:error, to_string(reason))
      |> new(%{})
    end
  end
  