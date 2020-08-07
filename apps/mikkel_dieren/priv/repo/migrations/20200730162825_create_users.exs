defmodule MikkelDieren.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :hashed_password, :string, null: false
      add :role, :string, default: "User"
      add :date_of_birth, :date, null: false
    end

    create unique_index(:users, [:username])
  end
end
