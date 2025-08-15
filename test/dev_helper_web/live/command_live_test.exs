defmodule DevHelperWeb.CommandLiveTest do
  use DevHelperWeb.ConnCase

  import Phoenix.LiveViewTest
  import DevHelper.CommandsFixtures

  @create_attrs %{description: "some description", title: "some title", content: "some content", tags: ["option1", "option2"]}
  @update_attrs %{description: "some updated description", title: "some updated title", content: "some updated content", tags: ["option1"]}
  @invalid_attrs %{description: nil, title: nil, content: nil, tags: []}

  setup :register_and_log_in_user

  defp create_command(%{scope: scope}) do
    command = command_fixture(scope)

    %{command: command}
  end

  describe "Index" do
    setup [:create_command]

    test "lists all commands", %{conn: conn, command: command} do
      {:ok, _index_live, html} = live(conn, ~p"/commands")

      assert html =~ "Listing Commands"
      assert html =~ command.title
    end

    test "saves new command", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/commands")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Command")
               |> render_click()
               |> follow_redirect(conn, ~p"/commands/new")

      assert render(form_live) =~ "New Command"

      assert form_live
             |> form("#command-form", command: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#command-form", command: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/commands")

      html = render(index_live)
      assert html =~ "Command created successfully"
      assert html =~ "some title"
    end

    test "updates command in listing", %{conn: conn, command: command} do
      {:ok, index_live, _html} = live(conn, ~p"/commands")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#commands-#{command.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/commands/#{command}/edit")

      assert render(form_live) =~ "Edit Command"

      assert form_live
             |> form("#command-form", command: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#command-form", command: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/commands")

      html = render(index_live)
      assert html =~ "Command updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes command in listing", %{conn: conn, command: command} do
      {:ok, index_live, _html} = live(conn, ~p"/commands")

      assert index_live |> element("#commands-#{command.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#commands-#{command.id}")
    end
  end

  describe "Show" do
    setup [:create_command]

    test "displays command", %{conn: conn, command: command} do
      {:ok, _show_live, html} = live(conn, ~p"/commands/#{command}")

      assert html =~ "Show Command"
      assert html =~ command.title
    end

    test "updates command and returns to show", %{conn: conn, command: command} do
      {:ok, show_live, _html} = live(conn, ~p"/commands/#{command}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/commands/#{command}/edit?return_to=show")

      assert render(form_live) =~ "Edit Command"

      assert form_live
             |> form("#command-form", command: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#command-form", command: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/commands/#{command}")

      html = render(show_live)
      assert html =~ "Command updated successfully"
      assert html =~ "some updated title"
    end
  end
end
