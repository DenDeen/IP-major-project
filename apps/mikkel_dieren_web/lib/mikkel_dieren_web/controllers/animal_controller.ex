defmodule MikkelDierenWeb.AnimalController do
  use MikkelDierenWeb, :controller

  alias MikkelDieren.UserContext
  alias MikkelDieren.AnimalContext
  alias MikkelDieren.AnimalContext.Animal

  action_fallback MikkelDierenWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    user = UserContext.get_user!(user_id)
    user_with_loaded_animals = AnimalContext.load_animals(user_id)
    render(conn, "index.json", animals: user_with_loaded_animals)
  end

  def create(conn, %{"user_id" => user_id, "animal" => animal_params}) do
    user = UserContext.get_user!(user_id)

    case AnimalContext.create_animal(animal_params, user) do
      {:ok, %Animal{} = animal} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_animal_path(conn, :show, user_id, animal))
        |> render("show.json", animal: animal)

      {:error, _cs} ->
        conn
        |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
    end
  end

  def show(conn, %{"id" => id}) do
    animal = AnimalContext.get_animal!(id)
    render(conn, "show.json", animal: animal)
  end

  def update(conn, %{"id" => id, "animal" => animal_params}) do
    animal = AnimalContext.get_animal!(id)

    case AnimalContext.update_animal(animal, animal_params) do
      {:ok, %Animal{} = animal} ->
        render(conn, "show.json", animal: animal)

      {:error, _cs} ->
        conn
        |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
    end
  end

  def delete(conn, %{"id" => id}) do
    animal = AnimalContext.get_animal!(id)

    with {:ok, %Animal{}} <- AnimalContext.delete_animal(animal) do
      send_resp(conn, :no_content, "")
    end
  end
end
