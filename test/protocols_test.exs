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
      errors = JTD.validate(@user_schema, @invalid_user)
      # IO.inspect(errors, label: "JTD validation errors")
      assert match?([_ | _], errors)
    end
  end

  describe "Avrora" do
    import ExUnit.CaptureLog

    setup _ do
      start_supervised!(AvroClient)

      {:ok, _schema} =
        :file.read_file("priv/avro/schemas/io/github/erszcz/protocols/User.avsc")
        |> elem(1)
        |> AvroClient.Schema.Encoder.from_json()

      :ok
    end

    test "starts AvroClient without an issue" do
      :ok
    end

    test "decodes a record with no embedded schema" do
      user = :file.read_file("priv/user.2.json") |> elem(1) |> Poison.decode!()

      log =
        capture_log(fn ->
          {:ok, decoded_user} =
            :file.read_file("priv/user.2.plain.avro")
            |> elem(1)
            |> AvroClient.decode_plain(schema_name: "io.github.erszcz.protocols.User")

          assert ^user = decoded_user
        end)

      assert log =~ "reading schema"
    end

    test "decodes a record with an embedded schema" do
      user = :file.read_file("priv/user.2.json") |> elem(1) |> Poison.decode!()

      log =
        capture_log(fn ->
          {:ok, decoded_user} =
            :file.read_file("priv/user.2.ocf.avro")
            |> elem(1)
            |> AvroClient.decode(schema_name: "io.github.erszcz.protocols.User")

          assert [^user] = decoded_user
        end)

      assert log =~ "message already contains embeded schema"
    end
  end
end
