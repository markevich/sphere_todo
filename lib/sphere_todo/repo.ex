defmodule SphereTodo.Repo do
  use Ecto.Repo,
    otp_app: :sphere_todo,
    adapter: Ecto.Adapters.Postgres
end
