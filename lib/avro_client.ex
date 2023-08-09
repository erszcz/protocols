defmodule AvroClient do
  use Avrora.Client,
    otp_app: :protocols,
    # registry_url: "http://localhost:8081",
    # registry_auth: {:basic, ["username", "password"]},
    # registry_user_agent: "Avrora/0.25.0 Elixir",
    schemas_path: "./priv/avro/schemas",
    registry_schemas_autoreg: false,
    convert_null_values: false,
    convert_map_to_proplist: false,
    names_cache_ttl: :timer.minutes(5),
    decoder_hook: &AvroClient.decoder_hook/4

  def decoder_hook(_type, _name_or_index, data, fun) do
    # IO.inspect({type, name_or_index, data}, label: :decoder_hook)
    fun.(data)
  end
end
