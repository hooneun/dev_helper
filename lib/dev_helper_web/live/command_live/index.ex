defmodule DevHelperWeb.CommandLive.Index do
  use DevHelperWeb, :live_view

  alias DevHelper.Commands

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Commands
        <:actions>
          <.button variant="primary" navigate={~p"/commands/new"}>
            <.icon name="hero-plus" /> New Command
          </.button>
        </:actions>
      </.header>

      <.table
        id="commands"
        rows={@streams.commands}
        row_click={fn {_id, command} -> JS.navigate(~p"/commands/#{command}") end}
      >
        <:col :let={{_id, command}} label="Title">{command.title}</:col>
        <:col :let={{_id, command}} label="Content">{command.content}</:col>
        <:col :let={{_id, command}} label="Description">{command.description}</:col>
        <:col :let={{_id, command}} label="Tags">{command.tags}</:col>
        <:action :let={{_id, command}}>
          <div class="sr-only">
            <.link navigate={~p"/commands/#{command}"}>Show</.link>
          </div>
          <.link navigate={~p"/commands/#{command}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, command}}>
          <.link
            phx-click={JS.push("delete", value: %{id: command.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Commands.subscribe_commands(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Commands")
     |> stream(:commands, Commands.list_commands(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    command = Commands.get_command!(socket.assigns.current_scope, id)
    {:ok, _} = Commands.delete_command(socket.assigns.current_scope, command)

    {:noreply, stream_delete(socket, :commands, command)}
  end

  @impl true
  def handle_info({type, %DevHelper.Commands.Command{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :commands, Commands.list_commands(socket.assigns.current_scope), reset: true)}
  end
end
