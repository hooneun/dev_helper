defmodule DevHelperWeb.CommandLive.Show do
  use DevHelperWeb, :live_view

  alias DevHelper.Commands

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Command {@command.id}
        <:subtitle>This is a command record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/commands"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/commands/#{@command}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit command
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@command.title}</:item>
        <:item title="Content">{@command.content}</:item>
        <:item title="Description">{@command.description}</:item>
        <:item title="Tags">{@command.tags}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Commands.subscribe_commands(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Command")
     |> assign(:command, Commands.get_command!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %DevHelper.Commands.Command{id: id} = command},
        %{assigns: %{command: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :command, command)}
  end

  def handle_info(
        {:deleted, %DevHelper.Commands.Command{id: id}},
        %{assigns: %{command: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current command was deleted.")
     |> push_navigate(to: ~p"/commands")}
  end

  def handle_info({type, %DevHelper.Commands.Command{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
