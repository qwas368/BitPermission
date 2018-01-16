defmodule BitPermissionTest do
  use ExUnit.Case
  doctest BitPermission

  test "can? raises FunctionClauseError when input invalid type" do
    assert_raise FunctionClauseError, fn ->
      BitPermission.can?("a string", 0)
    end

    assert_raise FunctionClauseError, fn ->
      BitPermission.can?(0.1, 0)
    end
  end

  test "can?/2 basic" do
    # 0b0001 & 0b0001
    assert BitPermission.can?(1, 1) == {:ok}
    # 0b0001 & 0b0010
    assert BitPermission.can?(1, 2) == {:error, :NO_PERMISSIONS}
    # 0b0010 & 0b0010
    assert BitPermission.can?(2, 2) == {:ok}
    # 0b0010 & 0b0011
    assert BitPermission.can?(2, 3) == {:ok}
  end

  test "can?/2 extreme" do
    assert BitPermission.can?(1_000_000_000_000_000, 1) == {:error, :NO_PERMISSIONS}
    assert BitPermission.can?(1_000_000_000_000_000, 1_000_000_000_000_000) == {:ok}
  end

  test "inherit/2  basic" do
    assert BitPermission.inherit(1, 3) == 3
    assert BitPermission.inherit(1, 1) == 1
    assert BitPermission.inherit(0, 1) == 1
  end

  test "inherit/2 extreme" do
    assert BitPermission.inherit(1_000_000_000_000_000, 1) == 1_000_000_000_000_001
  end

  test "remove/2 basic" do
    assert BitPermission.remove(1, 3) == 0
    assert BitPermission.remove(1, 0) == 1
    assert BitPermission.remove(7, 1) == 6
    assert BitPermission.remove(7, 3) == 4
    assert BitPermission.remove(8, 1) == 8
  end

  test "map/2 error handle" do
    assert BitPermission.to_atom_list(1, []) == []
    assert BitPermission.to_atom_list(0, [:create, :read, :write, :delete]) == []
  end

  test "map/2 basic" do
    assert BitPermission.to_atom_list(1, []) == []
    assert BitPermission.to_atom_list(0, [:create, :read, :write, :delete]) == []
    assert BitPermission.to_atom_list(1, [:create]) == [:create]
    assert BitPermission.to_atom_list(7, [:create, :read, :write, :delete]) == [:create, :read, :write]
    assert BitPermission.to_atom_list(15, [:create, :read, :write, :delete]) == [:create, :read, :write, :delete]
  end
end
