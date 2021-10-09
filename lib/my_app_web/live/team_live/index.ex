defmodule MyAppWeb.TeamLive.Index do
  use MyAppWeb, :live_view
  import MyAppWeb.LiveHelpers

  alias MyApp.Accounts
  alias MyApp.Accounts.Team

  on_mount MyAppWeb.LiveHelpers

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, :team_collection, list_team())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Team")
    |> assign(:team, Accounts.get_team!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Team")
    |> assign(:team, %Team{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Teams")
    |> assign(:team, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    team = Accounts.get_team!(id)
    {:ok, _} = Accounts.delete_team(team)

    {:noreply, assign(socket, :team_collection, list_team())}
  end

  defp list_team do
    Accounts.list_team()
  end
end
