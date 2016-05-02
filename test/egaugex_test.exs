defmodule EgaugexTest do
  use ExUnit.Case
  require Logger
  doctest Egaugex

  test "create_digest_auth_header creates digest header appropriately" do
    username = "test"
    password = "pwd"
    uri = "/someurl"
    realm = "test realm"

    auth_digest = Egaugex.Auth.create_digest_auth_header(username, password, uri, realm)
    assert Regex.match?(~r/^Digest username="test", realm="test realm", nonce="[0-9a-f]{32}", uri="\/someurl", response="[0-9a-f]{32}", opaque=""$/, to_string(auth_digest))
  end

  test "random_string creates random strings appropriately" do
    refute Egaugex.Auth.random_string(16) == Egaugex.Auth.random_string(16)
    assert String.length(Egaugex.Auth.random_string(16)) === 16
  end
end
