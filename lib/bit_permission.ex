defmodule BitPermission do
  @moduledoc false

  use Bitwise

  @doc """
  Compare user and target permissoion

  ## Examples

      iex> BitPermission.can?(1, 1)
      true

      iex> BitPermission.can?(1, 2)
      false

  """
  @spec can?(integer, integer) :: boolean
  def can?(user, target) when is_integer(user) and is_integer(target) do
    if (user &&& target) != 0 do
      true
    else
      false
    end
  end

  @doc """
  inherit base permission

  ## Examples

      iex> BitPermission.inherit(1, 3)
      3

      iex> BitPermission.inherit(1, 0)
      1

  """
  @spec inherit(integer, integer) :: integer
  def inherit(user, base) when is_integer(user) and is_integer(base) do
    Bitwise.bor(user, base)
  end

  @doc """
  remove a specified permission to user

  ## Examples

      iex> BitPermission.remove(1, 3)
      0

      iex> BitPermission.remove(1, 0)
      1

  """
  @spec remove(integer, integer) :: integer
  def remove(user, spec_permissions) when is_integer(user) and is_integer(spec_permissions) do
    user |> Bitwise.band(spec_permissions |> Bitwise.bnot)
  end

  @doc """
  integer-type permission to list-type permission

  ## Examples

      iex> BitPermission.to_list(0, [:create, :read, :write, :delete])
      []

      iex> BitPermission.to_list(1, [:create, :read, :write, :delete])
      [:create]

  """
  @spec to_list(integer, list) :: list
  def to_list(user, list) when is_integer(user) and is_list(list) do
    to_list(user, list, [])
  end

  defp to_list(_, [], acc), do: acc
  defp to_list(p, [head | tail], acc) do
    if(Bitwise.band(p, 1) == 1) do
      to_list(p >>> 1, tail, acc ++ [head])
    else
      to_list(p >>> 1, tail, acc)
    end
  end

  @doc """
  list-type permission to integer-type permission

  ## Examples

      iex> BitPermission.to_integer([:create, :read, :write, :delete])
      15

      iex> BitPermission.to_integer(["Personal", "Group", "Admin"])
      7

  """
  @spec to_integer(list) :: list
  def to_integer(list) when is_list(list) do
    to_integer(list, list, 0)
  end

  @doc """
  list-type permission to integer-type permission

  ## Examples

      iex> BitPermission.to_integer([], [:create, :read, :write, :delete])
      0

      iex> BitPermission.to_integer([:create], [:create, :read, :write, :delete])
      1

  """
  @spec to_integer(list, list) :: list
  def to_integer(user, list) when is_list(user) and is_list(list) do
    to_integer(user, list, 0)
  end

  defp to_integer(_, [], acc), do: acc
  defp to_integer([], _, acc), do: acc
  defp to_integer(user, [head | tail], acc) do
    [u_head | u_tail] = user
    if(u_head == head) do
      to_integer(u_tail, tail, (acc <<< 1) + 1)
    else
      to_integer(user, tail, acc <<< 1)
    end
  end
end
