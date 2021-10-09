defmodule MyApp.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyApp.Accounts` context.
  """
  alias MyApp.Repo

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      email_confirmed_at: DateTime.utc_now()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Repo.create()

    user
  end

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> MyApp.Accounts.create_team()

    team
  end
end
