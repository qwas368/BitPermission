defmodule PermissionsTest do
  use ExUnit.Case
  doctest Permissions

  test "can? raises FunctionClauseError when input invalid type" do
    assert_raise FunctionClauseError, fn ->
      Permissions.can?("a string", 0)
    end

    assert_raise FunctionClauseError, fn ->
      Permissions.can?(0.1, 0)
    end
  end

  test "can?/2 basic" do
    # 0b0001 & 0b0001
    assert Permissions.can?(1, 1) == {:ok}
    # 0b0001 & 0b0010
    assert Permissions.can?(1, 2) == {:error, :NO_PERMISSIONS}
    # 0b0010 & 0b0010
    assert Permissions.can?(2, 2) == {:ok}
    # 0b0010 & 0b0011
    assert Permissions.can?(2, 3) == {:ok}
  end

  test "can?/2 extreme" do
    assert Permissions.can?(1_000_000_000_000_000, 1) == {:error, :NO_PERMISSIONS}
    assert Permissions.can?(1_000_000_000_000_000, 1_000_000_000_000_000) == {:ok}
  end

  test "inherit/2  basic" do
    assert Permissions.inherit(1, 3) == 3
    assert Permissions.inherit(1, 1) == 1
    assert Permissions.inherit(0, 1) == 1
  end

  test "inherit/2 extreme" do
    assert Permissions.inherit(1_000_000_000_000_000, 1) == 1_000_000_000_000_001
  end

  test "remove/2 basic" do
    assert Permissions.remove(1, 3) == 0
    assert Permissions.remove(1, 0) == 1
    assert Permissions.remove(7, 1) == 6
    assert Permissions.remove(7, 3) == 4
    assert Permissions.remove(8, 1) == 8
  end

  test "map/2 error handle" do
    assert Permissions.to_atom_list(1, []) == []
    assert Permissions.to_atom_list(0, [:create, :read, :write, :delete]) == []
  end

  test "map/2 basic" do
    assert Permissions.to_atom_list(1, []) == []
    assert Permissions.to_atom_list(0, [:create, :read, :write, :delete]) == []
    assert Permissions.to_atom_list(1, [:create]) == [:create]
    assert Permissions.to_atom_list(7, [:create, :read, :write, :delete]) == [:create, :read, :write]
    assert Permissions.to_atom_list(15, [:create, :read, :write, :delete]) == [:create, :read, :write, :delete]
    assert Permissions.to_atom_list(0, ["create", "select"]) == []
  end
end
