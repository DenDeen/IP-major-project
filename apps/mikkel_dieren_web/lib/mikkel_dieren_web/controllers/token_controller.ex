defmodule MikkelDierenWeb.TokenController do
    use MikkelDierenWeb, :controller
  
    alias MikkelDieren.UserContext
    alias MikkelDieren.AuthTokenContext

    def token(conn, _params) do
        token = conn.cookies["bearer"]
        render(conn, "token.html", token: token)
    end

    def show(conn, %{"id" => id}) do
        token = AuthTokenContext.get_auth_token!(id)
        user = UserContext.get_user!(token.user_id)
        render(conn, "show.html", token: token, user: user.username)
    end

    def delete(conn, %{"id" => id}) do
        token = AuthTokenContext.get_auth_token!(id)
        user = UserContext.get_user!(token.user_id)
        {:ok, _token} = AuthTokenContext.delete_auth_token(token)
    
        conn
        |> put_flash(:info, "Token deleted successfully.")
        |> redirect(to: Routes.edit_path(conn, :index, user))
    end
end

