defmodule MikkelDierenWeb.AnimalView do
  use MikkelDierenWeb, :view
  alias MikkelDierenWeb.AnimalView

  def render("index.json", %{animals: animals}) do
    %{data: render_many(animals, AnimalView, "animal.json")}
  end

  def render("show.json", %{animal: animal}) do
    %{data: render_one(animal, AnimalView, "animal.json")}
  end

  def render("animal.json", %{animal: animal}) do
    %{id: animal.id,
      name: animal.name,
      dob: animal.dob,
      cat_or_dog: animal.cat_or_dog}
  end
end
