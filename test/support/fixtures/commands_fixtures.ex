defmodule DevHelper.CommandsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DevHelper.Commands` context.
  """

  @doc """
  Generate a unique command title.
  """
  def unique_command_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a command.
  """
  def command_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        content: "some content",
        description: "some description",
        tags: ["option1", "option2"],
        title: unique_command_title()
      })

    {:ok, command} = DevHelper.Commands.create_command(scope, attrs)
    command
  end
end
