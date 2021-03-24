defmodule StoneChallenge do
  @moduledoc """
  Solves Stone's 'Programa de Formação em Elixir' challenge.

  The challenge mainly consist on a basic supermarket division where you have a list of items,
  their price and the amount that is being purchased and should calculate the total sum and
  divide by the number of participants represented by their emails in the most equal way.
  """

  @typep items :: %{
           name: String.t(),
           amount: integer(),
           quantity: integer()
         }

  @doc """
  Calculates total sum for the market receipt and splits in the most equal way between participants.
  """
  @spec split(items_list :: list(items()), emails_list :: list()) :: map() | {:error, atom()}
  def split([], []), do: {:error, :empty_lists}
  def split(_, []), do: {:error, :empty_emails_list}
  def split([], _), do: {:error, :empty_shopping_list}

  def split(items_list, emails_list) when is_list(items_list) and is_list(items_list) do
    emails_list = Enum.uniq(emails_list)

    total_amount = calculate_total_amount(items_list)

    do_split(emails_list, total_amount)
  end

  defp do_split(emails_list, total_amount) do
    emails_qty = length(emails_list)

    each_part = div(total_amount, emails_qty)
    remainder = rem(total_amount, emails_qty)

    splitted =
      Enum.reduce(emails_list, %{}, fn email, splitted ->
        Map.put(splitted, email, each_part)
      end)

    split_remainder(splitted, remainder)
  end

  defp split_remainder(splitted, 0), do: splitted

  defp split_remainder(splitted, remainder) do
    %{res: splitted_res} =
      Enum.reduce(splitted, %{res: %{}, rem: remainder}, fn
        {email, amount}, %{res: %{}, rem: 0} = acc ->
          %{res: Map.put(acc.res, email, amount), rem: 0}

        {email, amount}, acc ->
          %{res: Map.put(acc.res, email, amount + 1), rem: acc.rem - 1}
      end)

    splitted_res
  end

  defp calculate_total_amount(items_list) do
    Enum.reduce(items_list, 0, fn item, acc ->
      unless item.quantity > 0 and item.amount > 0 do
        raise ArgumentError, message: "values should be greather than 0"
      end

      item.amount * item.quantity + acc
    end)
  end
end
