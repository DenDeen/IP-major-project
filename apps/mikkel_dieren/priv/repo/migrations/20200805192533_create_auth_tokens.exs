defmodule MikkelDieren.Repo.Migrations.CreateAuthTokens do
  use Ecto.Migration

  def change do
    create table(:auth_tokens) do
      add :token, :text
      add :name, :text
      add :user_id, references(:users, on_delete: :nothing), null: false
    end

    create index(:auth_tokens, [:user_id])
  end
end
