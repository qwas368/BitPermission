defmodule Permissions do
  @moduledoc false

  use Bitwise

  @doc """
  Compare user and target permissoion

  ## Examples

      iex> Permissions.can?(1, 1)
      {:ok}

      iex> Permissions.can?(1, 2)
      {:error, :NO_PERMISSIONS}

  """
  @spec can?(integer, integer) :: boolean
  def can?(user, target) when is_integer(user) and is_integer(target) do
    if (user &&& target) != 0 do
      {:ok}
    else
      {:error, :NO_PERMISSIONS}
    end
  end

  @doc """
  inherit base permission

  ## Examples

      iex> Permissions.inherit(1, 3)
      3

      iex> Permissions.inherit(1, 0)
      1

  """
  @spec inherit(integer, integer) :: integer
  def inherit(user, base) when is_integer(user) and is_integer(base) do
    Bitwise.bor(user, base)
  end

  @doc """
  remove specified permission to user

  ## Examples

      iex> Permissions.remove(1, 3)
      0

      iex> Permissions.remove(1, 0)
      1

  """
  @spec remove(integer, integer) :: integer
  def remove(user, spec_permissions) when is_integer(user) and is_integer(spec_permissions) do
    user |> Bitwise.band(spec_permissions |> Bitwise.bnot)
  end
end
