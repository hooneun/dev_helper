defmodule DevHelper.Commands.Command do
  use Ecto.Schema
  import Ecto.Changeset

  schema "commands" do
    field :title, :string
    field :content, :string
    field :description, :string
    field :tags, {:array, :string}
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(command, attrs, user_scope) do
    command
    |> cast(attrs, [:title, :content, :description, :tags])
    |> validate_required([:title, :content, :description, :tags])
    |> unique_constraint(:title)
    |> put_change(:user_id, user_scope.user.id)
  end
end
