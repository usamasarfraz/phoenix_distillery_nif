defmodule PhoenixDistillery.TextConversion do
  use GenServer

  # Client

  def start_link(default) when is_binary(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def push(element) do
    GenServer.call(__MODULE__, {:push, element})
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def convert_string(path) do
    GenServer.call(__MODULE__, {:convert, path}, 5000000)
  end

  # Server (callbacks)

  @impl true
  def init(elements) do
    elements_list = String.split(elements, ",", trim: true)
    {:ok, %{"counter" => 0, "elements" => elements_list}}
  end

  @impl true
  def handle_call(:pop, _from, %{"counter" => counter, "elements" => elements}) do
    if elements === [] do
      {:reply, :List_is_empty, elements}
    else
      [to_caller | new_elements] = elements
      {:reply, to_caller, %{"counter" => counter + 1, "elements" => new_elements}}
    end
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:push, element}, _from, %{"counter" => counter, "elements" => elements}) do
    new_list = [element | elements]
    {:reply, %{"counter" => counter + 1, "elements" => new_list}, %{"counter" => counter + 1, "elements" => new_list}}
  end

  @impl true
  def handle_call({:convert, path}, _from, state) do
    # "C:/Users/usama/Desktop/long_string.txt"
    starting_version = Application.spec(:phoenix_distillery)[:vsn]
    starting_time = DateTime.utc_now()
    # {:ok, text} = File.read(path)
    # IO.inspect("------------------READ COMPLETED----------------------")
    # converted_string = convertion(text)
    lower_case_string = PhoenixDistillery.NifDemo.read_file(path)
    IO.inspect("------------------CONVERSION COMPLETED FROM RUST NIF----------------------")
    converted_string = convertion(lower_case_string)
    IO.inspect("------------------CONVERSION COMPLETED FROM ELIXIR----------------------")
    end_time = DateTime.utc_now()
    diff = DateTime.diff(end_time, starting_time, :microsecond)
    ending_version = Application.spec(:phoenix_distillery)[:vsn]
    File.write(path, "vsn: #{starting_version}-----------#{converted_string}-----------vsn: #{ending_version}---------Time Taken: #{diff} microseconds.")
    {:reply, converted_string, state}
  end

  defp convertion(text) do
    # first version
    converted_text =
    text
    |> String.capitalize()
    "#{converted_text}."

    # second version
    # converted_text =
    # text
    # |> String.capitalize()
    # "AA#{converted_text}..."
  end

  # @impl true
  # def code_change(_old_vsn, state, counter) do
  #   {:ok, %{"counter" => counter, "elements" => state}}
  # end
end
