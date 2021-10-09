defmodule MyApp.AccountsTest do
  use MyApp.DataCase

  alias MyApp.{Accounts, Accounts.User}

  @valid_params %{
    email: "test@example.com",
    password: "secret1234",
    password_confirmation: "secret1234"
  }

  test "create_user/2" do
    {:ok, user} = Accounts.create_user(@valid_params)

    assert user.role == "user"
  end

  test "set_role/2" do
    {:ok, user} = Accounts.create_user(@valid_params)
    {:ok, user} = Accounts.set_role(user, "admin")

    assert user.role == "admin"
  end

  test "user_has_role?/1" do
    user = %User{role: "admin"}

    assert true == Accounts.user_has_role?(user, :admin)
    assert false == Accounts.user_has_role?(user, :super_admin)
  end

  describe "team" do
    alias MyApp.Accounts.Team

    import MyApp.AccountsFixtures

    @invalid_attrs %{name: nil}

    test "list_team/0 returns all team" do
      team = team_fixture()
      assert Accounts.list_team() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Accounts.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Team{} = team} = Accounts.create_team(valid_attrs)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = Accounts.update_team(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_team(team, @invalid_attrs)
      assert team == Accounts.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Accounts.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Accounts.change_team(team)
    end
  end
end
