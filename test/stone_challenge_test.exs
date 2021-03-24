defmodule StoneChallengeTest do
  use ExUnit.Case, async: true

  describe "split/1" do
    for quantity <- [0, -1] do
      test "should raise if value is #{quantity}" do
        quantity = unquote(quantity)

        assert_raise ArgumentError, fn ->
          StoneChallenge.split([%{item: "arroz", amount: 101, quantity: quantity}], [
            "email1",
            "email2",
            "email3"
          ])
        end
      end
    end

    test "should error upon empty lists" do
      assert {:error, :empty_lists} == StoneChallenge.split([], [])
    end

    test "should error upon empty email list" do
      assert {:error, :empty_emails_list} == StoneChallenge.split([%{}], [])
    end

    test "should error upon empty items lists" do
      assert {:error, :empty_shopping_list} == StoneChallenge.split([], ["email1"])
    end

    test "should split receipt in the most equal way when there is a remainder" do
      assert %{"email1" => 33} =
               StoneChallenge.split([%{item: "arroz", amount: 101, quantity: 1}], [
                 "email1",
                 "email2",
                 "email3"
               ])
    end

    test "should split receipt equally when there is no remainder" do
      assert %{"email1" => 1, "email2" => 1, "email3" => 1} ==
               StoneChallenge.split([%{item: "arroz", amount: 3, quantity: 1}], [
                 "email1",
                 "email2",
                 "email3"
               ])
    end
  end
end
