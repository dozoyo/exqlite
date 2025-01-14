defmodule Ecto.Integration.TimestampsTest do
  use Ecto.Integration.Case

  alias Ecto.Integration.TestRepo

  import Ecto.Query

  defmodule UserNaiveDatetime do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field(:name, :string)
      timestamps()
    end

    def changeset(struct, attrs) do
      struct
      |> cast(attrs, [:name])
      |> validate_required([:name])
    end
  end

  defmodule UserUtcDatetime do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field(:name, :string)
      timestamps(type: :utc_datetime)
    end

    def changeset(struct, attrs) do
      struct
      |> cast(attrs, [:name])
      |> validate_required([:name])
    end
  end

  test "insert and fetch naive datetime" do
    {:ok, user} =
      %UserNaiveDatetime{}
      |> UserNaiveDatetime.changeset(%{name: "Bob"})
      |> TestRepo.insert()

    user =
      UserNaiveDatetime
      |> select([u], u)
      |> where([u], u.id == ^user.id)
      |> TestRepo.one()

    assert user
  end

  test "insert and fetch utc datetime" do
    {:ok, user} =
      %UserUtcDatetime{}
      |> UserUtcDatetime.changeset(%{name: "Bob"})
      |> TestRepo.insert()

    user =
      UserUtcDatetime
      |> select([u], u)
      |> where([u], u.id == ^user.id)
      |> TestRepo.one()

    assert user
  end
end
