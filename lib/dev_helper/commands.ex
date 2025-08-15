defmodule DevHelper.Commands do
  @moduledoc """
  The Commands context.
  """

  import Ecto.Query, warn: false
  alias DevHelper.Repo

  alias DevHelper.Commands.Command
  alias DevHelper.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any command changes.

  The broadcasted messages match the pattern:

    * {:created, %Command{}}
    * {:updated, %Command{}}
    * {:deleted, %Command{}}

  """
  def subscribe_commands(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(DevHelper.PubSub, "user:#{key}:commands")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(DevHelper.PubSub, "user:#{key}:commands", message)
  end

  @doc """
  Returns the list of commands.

  ## Examples

      iex> list_commands(scope)
      [%Command{}, ...]

  """
  def list_commands(%Scope{} = scope) do
    Repo.all_by(Command, user_id: scope.user.id)
  end

  @doc """
  Gets a single command.

  Raises `Ecto.NoResultsError` if the Command does not exist.

  ## Examples

      iex> get_command!(scope, 123)
      %Command{}

      iex> get_command!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_command!(%Scope{} = scope, id) do
    Repo.get_by!(Command, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a command.

  ## Examples

      iex> create_command(scope, %{field: value})
      {:ok, %Command{}}

      iex> create_command(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_command(%Scope{} = scope, attrs) do
    with {:ok, command = %Command{}} <-
           %Command{}
           |> Command.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, command})
      {:ok, command}
    end
  end

  @doc """
  Updates a command.

  ## Examples

      iex> update_command(scope, command, %{field: new_value})
      {:ok, %Command{}}

      iex> update_command(scope, command, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_command(%Scope{} = scope, %Command{} = command, attrs) do
    true = command.user_id == scope.user.id

    with {:ok, command = %Command{}} <-
           command
           |> Command.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, command})
      {:ok, command}
    end
  end

  @doc """
  Deletes a command.

  ## Examples

      iex> delete_command(scope, command)
      {:ok, %Command{}}

      iex> delete_command(scope, command)
      {:error, %Ecto.Changeset{}}

  """
  def delete_command(%Scope{} = scope, %Command{} = command) do
    true = command.user_id == scope.user.id

    with {:ok, command = %Command{}} <-
           Repo.delete(command) do
      broadcast(scope, {:deleted, command})
      {:ok, command}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking command changes.

  ## Examples

      iex> change_command(scope, command)
      %Ecto.Changeset{data: %Command{}}

  """
  def change_command(%Scope{} = scope, %Command{} = command, attrs \\ %{}) do
    true = command.user_id == scope.user.id

    Command.changeset(command, attrs, scope)
  end
end
