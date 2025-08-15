defmodule DevHelper.Repo do
  use Ecto.Repo,
    otp_app: :dev_helper,
    adapter: Ecto.Adapters.Postgres
end
