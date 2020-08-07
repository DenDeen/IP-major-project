# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MikkelDieren.Repo.insert!(%MikkelDieren.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, _cs} =
  MikkelDieren.UserContext.create_user(%{
    "username" => "user", 
    "first_name" => "first", 
    "last_name" => "last", 
    "password" => "t", 
    "role" => "User", 
    "date_of_birth" => "1997-12-21"
})

{:ok, _cs} =
MikkelDieren.UserContext.create_user(%{
    "username" => "admin",
    "first_name" => "first", 
    "last_name" => "last", 
    "password" => "t", 
    "role" => "Admin", 
    "date_of_birth" => "1997-12-21"
})