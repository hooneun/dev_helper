defmodule DevHelper.CommandsTest do
  use DevHelper.DataCase

  alias DevHelper.Commands

  describe "commands" do
    alias DevHelper.Commands.Command

    import DevHelper.AccountsFixtures, only: [user_scope_fixture: 0]
    import DevHelper.CommandsFixtures

    @invalid_attrs %{description: nil, title: nil, content: nil, tags: nil}

    test "list_commands/1 returns all scoped commands" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      command = command_fixture(scope)
      other_command = command_fixture(other_scope)
      assert Commands.list_commands(scope) == [command]
      assert Commands.list_commands(other_scope) == [other_command]
    end

    test "get_command!/2 returns the command with given id" do
      scope = user_scope_fixture()
      command = command_fixture(scope)
      other_scope = user_scope_fixture()
      assert Commands.get_command!(scope, command.id) == command
      assert_raise Ecto.NoResultsError, fn -> Commands.get_command!(other_scope, command.id) end
    end

    test "create_command/2 with valid data creates a command" do
      valid_attrs = %{description: "some description", title: "some title", content: "some content", tags: ["option1", "option2"]}
      scope = user_scope_fixture()

      assert {:ok, %Command{} = command} = Commands.create_command(scope, valid_attrs)
      assert command.description == "some description"
      assert command.title == "some title"
      assert command.content == "some content"
      assert command.tags == ["option1", "option2"]
      assert command.user_id == scope.user.id
    end

    test "create_command/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Commands.create_command(scope, @invalid_attrs)
    end

    test "update_command/3 with valid data updates the command" do
      scope = user_scope_fixture()
      command = command_fixture(scope)
      update_attrs = %{description: "some updated description", title: "some updated title", content: "some updated content", tags: ["option1"]}

      assert {:ok, %Command{} = command} = Commands.update_command(scope, command, update_attrs)
      assert command.description == "some updated description"
      assert command.title == "some updated title"
      assert command.content == "some updated content"
      assert command.tags == ["option1"]
    end

    test "update_command/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      command = command_fixture(scope)

      assert_raise MatchError, fn ->
        Commands.update_command(other_scope, command, %{})
      end
    end

    test "update_command/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      command = command_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Commands.update_command(scope, command, @invalid_attrs)
      assert command == Commands.get_command!(scope, command.id)
    end

    test "delete_command/2 deletes the command" do
      scope = user_scope_fixture()
      command = command_fixture(scope)
      assert {:ok, %Command{}} = Commands.delete_command(scope, command)
      assert_raise Ecto.NoResultsError, fn -> Commands.get_command!(scope, command.id) end
    end

    test "delete_command/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      command = command_fixture(scope)
      assert_raise MatchError, fn -> Commands.delete_command(other_scope, command) end
    end

    test "change_command/2 returns a command changeset" do
      scope = user_scope_fixture()
      command = command_fixture(scope)
      assert %Ecto.Changeset{} = Commands.change_command(scope, command)
    end
  end
end
