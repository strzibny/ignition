defmodule MyAppWeb.TeamLive.FormComponent do
  use MyAppWeb, :live_component

  alias MyApp.Accounts

  @impl true
  def update(%{team: team} = assigns, socket) do
    changeset = Accounts.change_team(team)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"team" => team_params}, socket) do
    changeset =
      socket.assigns.team
      |> Accounts.change_team(team_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"team" => team_params}, socket) do
    save_team(socket, socket.assigns.action, team_params)
  end

  defp save_team(socket, :edit, team_params) do
    case Accounts.update_team(socket.assigns.team, team_params) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "team updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_team(socket, :new, team_params) do
    case Accounts.create_team(team_params) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "team created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end