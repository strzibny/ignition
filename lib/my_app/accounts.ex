defmodule MyApp.Accounts do
  alias MyApp.{Repo, Accounts.User}

  @type t :: %User{}

  @spec create_user(map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> User.changeset_role(%{role: "user"})
    |> Repo.insert()
  end

  @spec set_role(t(), binary()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def set_role(user, role) do
    user
    |> User.changeset_role(%{role: role})
    |> Repo.update()
  end

  @spec user_has_role?(t() | nil, binary() | list()) :: bool()
  def user_has_role?(nil, _roles), do: false

  def user_has_role?(user, roles) when is_list(roles),
    do: Enum.any?(roles, &user_has_role?(user, &1))

  def user_has_role?(user, role) when is_atom(role),
    do: user_has_role?(user, Atom.to_string(role))

  def user_has_role?(%{role: role}, role), do: true
  def user_has_role?(_user, _role), do: false
end
