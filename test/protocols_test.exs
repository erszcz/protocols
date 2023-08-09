defmodule ProtocolsTest do
  use ExUnit.Case

  describe "JTD" do
    @user_schema Poison.decode!("""
                 {
                   "properties": {
                     "id": { "type": "string" },
                     "createdAt": { "type": "timestamp" },
                     "karma": { "type": "int32" },
                     "isAdmin": { "type": "boolean" }
                   }
                 }
                 """)
                 |> JTD.Schema.from_map()
    @invalid_user Poison.decode!("""
                  {
                    "id": 123
                  }
                  """)
    @valid_user Poison.decode!("""
                {
                 "id": "1",
                 "createdAt": "2023-08-09T14:05:22Z",
                 "karma": 123,
                 "isAdmin": false
                }
                """)

    test "validates a valid object without errors" do
      assert [] == JTD.validate(@user_schema, @valid_user)
    end

    test "returns validation errors for an invalid object" do
      assert match?([_ | _], JTD.validate(@user_schema, @invalid_user))
    end
  end
end
