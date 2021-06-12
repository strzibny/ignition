defmodule MyApp.UsersTest do
  use MyApp.DataCase

  alias MyApp.{Repo, Users, Users.User}

  @valid_params %{
    email: "test@example.com",
    password: "secret1234",
    password_confirmation: "secret1234"
  }

  test "create_user/2" do
    {:ok, user} = Users.create_user(@valid_params)

    assert user.role == "user"
  end

  test "set_role/2" do
    {:ok, user} = Users.create_user(@valid_params)
    {:ok, user} = Users.set_role(user, "admin")

    assert user.role == "admin"
  end

  test "user_has_role?/1" do
    user = %Users.User{role: "admin"}

    assert true == Users.user_has_role?(user, :admin)
    assert false == Users.user_has_role?(user, :super_admin)
  end
end
