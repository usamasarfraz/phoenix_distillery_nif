defmodule PhoenixDistillery.NifDemo do
  use Rustler, otp_app: :phoenix_distillery, crate: "niflib"

  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
  def read_file(_path), do: :erlang.nif_error(:nif_not_loaded)

  def load do
    :erlang.load_nif("./priv/native/libniflib","test")
  end

end
