defmodule DevHelperWeb.CommandLive.Form do
  use DevHelperWeb, :live_view

  alias DevHelper.Commands
  alias DevHelper.Commands.Command

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage command records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="command-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:content]} type="textarea" label="Content" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input
          field={@form[:tags]}
          type="select"
          multiple
          label="Tags"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Command</.button>
          <.button navigate={return_path(@current_scope, @return_to, @command)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    command = Commands.get_command!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Command")
    |> assign(:command, command)
    |> assign(:form, to_form(Commands.change_command(socket.assigns.current_scope, command)))
  end

  defp apply_action(socket, :new, _params) do
    command = %Command{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Command")
    |> assign(:command, command)
    |> assign(:form, to_form(Commands.change_command(socket.assigns.current_scope, command)))
  end

  @impl true
  def handle_event("validate", %{"command" => command_params}, socket) do
    changeset = Commands.change_command(socket.assigns.current_scope, socket.assigns.command, command_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"command" => command_params}, socket) do
    save_command(socket, socket.assigns.live_action, command_params)
  end

  defp save_command(socket, :edit, command_params) do
    case Commands.update_command(socket.assigns.current_scope, socket.assigns.command, command_params) do
      {:ok, command} ->
        {:noreply,
         socket
         |> put_flash(:info, "Command updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, command)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_command(socket, :new, command_params) do
    case Commands.create_command(socket.assigns.current_scope, command_params) do
      {:ok, command} ->
        {:noreply,
         socket
         |> put_flash(:info, "Command created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, command)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _command), do: ~p"/commands"
  defp return_path(_scope, "show", command), do: ~p"/commands/#{command}"
end
