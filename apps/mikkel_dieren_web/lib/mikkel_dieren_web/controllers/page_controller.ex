defmodule MikkelDierenWeb.PageController do
  use MikkelDierenWeb, :controller
  import Guardian.Plug

  alias MikkelDieren.UserContext
  alias MikkelDieren.AnimalContext

  def index(conn, _params) do
    render(conn, "index.html", role: "everyone", current_user: nil, animals: nil)
  end

  def user_index(conn, _params) do
    current_user = current_resource(conn)
    animals = AnimalContext.load_animals(current_user.id)
    render(conn, "index.html", role: "users", animals: animals)
  end

  def admin_index(conn, _params) do
    current_user = current_resource(conn)
    animals = AnimalContext.load_animals(current_user.id)
    render(conn, "index.html", role: "admins", animals: animals)
  end
end
