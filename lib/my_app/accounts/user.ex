defmodule MyApp.Accounts.User do
  use Ecto.Schema

  use Pow.Ecto.Schema,
    password_hash_methods: {&Argon2.hash_pwd_salt/1, &Argon2.verify_pass/2}

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  schema "users" do
    pow_user_fields()

    field :role, :string, null: false, default: "user"

    timestamps()
  end

  @spec changeset(Ecto.Schema.t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  @spec changeset_role(Ecto.Schema.t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role])
    |> Ecto.Changeset.validate_inclusion(:role, ~w(user admin super_admin))
  end
end
