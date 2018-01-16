defmodule BitPermission do
  @moduledoc false

  use Bitwise

  @doc """
  Compare user and target permissoion

  ## Examples

      iex> BitPermission.can?(1, 1)
      {:ok}

      iex> BitPermission.can?(1, 2)
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
  bit-type permission to atom-list permission

  ## Examples

      iex> BitPermission.to_atom_list(0, [:create, :read, :write, :delete])
      []

      iex> BitPermission.to_atom_list(1, [:create, :read, :write, :delete])
      [:create]

  """
  @spec to_atom_list(integer, list) :: list
  def to_atom_list(user, list) when is_integer(user) and is_list(list) do
    map_permissions(user, list, [])
  end

  defp map_permissions(_, [], acc), do: acc
  defp map_permissions(p, [head | tail], acc) do
    if(Bitwise.band(p, 1) == 1) do
      map_permissions(p >>> 1, tail, acc ++ [head])
    else
      map_permissions(p >>> 1, tail, acc)
    end
  end

  @doc """
  atom-list permission to bit-type permission

  ## Examples

      iex> BitPermission.to_bit_type([], [:create, :read, :write, :delete])
      0

      iex> BitPermission.to_bit_type([:create], [:create, :read, :write, :delete])
      1

  """
  # @spec to_bit_type(integer, list) :: list
  # def to_bit_type(user, list) when is_list(user) and is_list(list) do
  #   map_permissions(user, list, [])
  # end
end
