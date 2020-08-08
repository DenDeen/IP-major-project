defmodule MikkelDierenWeb.Plugs.Authenticate do
    import Plug.Conn

    alias MikkelDieren.AuthTokenContext
    alias MikkelDieren.AuthTokenContext.AuthToken
    alias MikkelDieren.Repo

    def init(default), do: default

    def call(conn, _default) do
      case AuthTokenContext.get_auth_token_header(conn) do
        {:ok, token} ->
          IO.puts(token)
          case MikkelDieren.Repo.get_by(AuthToken, %{token: token}) |> Repo.preload(:user) do
            nil -> unauthorized(conn)
            auth_token -> authorized(conn, auth_token)
          end
        _ -> 
            IO.puts("token")
            unauthorized(conn)
      end
    end

    defp authorized(conn, auth_token) do
      conn
       |> assign(:is_writable, auth_token.is_writable)
    end
    
    defp unauthorized(conn) do
      conn |> send_resp(401, "Unauthorized") |> halt()
    end
end