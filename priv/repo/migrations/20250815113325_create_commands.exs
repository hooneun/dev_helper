defmodule DevHelper.Repo.Migrations.CreateCommands do
  use Ecto.Migration

  def change do
    create table(:commands) do
      add :title, :string
      add :content, :text
      add :description, :text
      add :tags, {:array, :string}
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:commands, [:user_id])

    create unique_index(:commands, [:title])
  end
end
