defmodule PhoenixDistillery.Test do
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

  # @impl true
  # def code_change(_old_vsn, state, counter) do
  #   {:ok, %{"counter" => counter, "elements" => state}}
  # end
end
