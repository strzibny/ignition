defmodule MyAppWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `MyAppWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal MyAppWeb.TeamLive.FormComponent,
        id: @team.id || :new,
        action: @live_action,
        team: @team,
        return_to: Routes.team_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(MyAppWeb.ModalComponent, modal_opts)
  end

  # Pow

  alias Pow.Store.CredentialsCache
  alias Pow.Store.Backend.MnesiaCache

  # for on_mount

  def mount(params, %{"current_user_id" => user_id} = session, socket) do
    socket = assign_defaults(socket, session)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/session/new ")}
    end
  end

  def mount(params, session, socket) do
    {:halt, redirect(socket, to: "/session/new ")}
  end

  ## Helpers

  @doc """
  Fetches current user details from session, if present
  """
  def assign_defaults(socket, session) do
    assign_new(socket, :current_user, fn -> get_user(socket, session) end)
  end

  defp get_user(socket, session, config \\ [otp_app: :my_app])

  defp get_user(socket, %{"my_app_auth" => signed_token}, config) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)

    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, signed_token, config),
         {user, _metadata} <- CredentialsCache.get([backend: MnesiaCache], token) do
      user
    else
      _ -> nil
    end
  end

  defp get_user(_, _, _), do: nil
end
