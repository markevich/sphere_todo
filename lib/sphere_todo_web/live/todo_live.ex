defmodule SphereTodoWeb.TodoLive do
  # defmodule Example do
  #   def subscribe do
  #     SphereTodo.Todos.subscribe()
  #   end

  #   def handle_info({Todos, [:todo | _], _}, socket) do
  #     IO.inspect(socket)
  #   end
  # end

  use Phoenix.LiveView

  alias SphereTodo.Todos
  alias SphereTodoWeb.TodoView

  def mount(_session, socket) do
    Todos.subscribe()

    {:ok, fetch(socket)}
  end

  def render(assigns) do
    TodoView.render("todos.html", assigns)
  end

  def handle_event("add", %{"todo" => todo}, socket) do
    Todos.create_todo(todo)

    {:noreply, fetch(socket)}
  end

  def handle_event("toggle_done", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{done: !todo.done})
    {:noreply, fetch(socket)}
  end

  def handle_event("change", %{"todo" => %{"id" => id, "title" => title, "done" => done}}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{title: title, done: done})
    {:noreply, fetch(socket)}
  end

  def handle_event("set_filter", %{"filter" => filter}, socket) do
    {
      :noreply,
      socket
      |> assign(filter: filter)
      |> fetch
    }
  end

  def handle_info({Todos, [:todo | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    filter = Map.get(socket.assigns, :filter, "all")

    todos =
      case filter do
        "all" -> Todos.list_todos()
        "active" -> Todos.list_active_todos()
        "completed" -> Todos.list_completed_todos()
      end

    uncompleted_count = Todos.uncompleted_count(todos)

    assign(socket, todos: todos, uncompleted_count: uncompleted_count, filter: filter)
  end
end
