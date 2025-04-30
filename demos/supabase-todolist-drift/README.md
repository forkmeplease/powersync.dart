# PowerSync + Supabase + Drift Flutter Demo: Todo List App

This demo app is an extension of the [Supabase Todo List App](../supabase-todolist/README.md) and showcases how to set up and use the [drift_sqlite_async](https://pub.dev/packages/drift_sqlite_async) library (Drift ORM) with PowerSync.
This demo also uses [riverpod](https://riverpod.dev) to highlight best practices for state management.

Notes about the Drift usage are [further below](#drift).

# Running the app

Ensure you have [melos](https://melos.invertase.dev/~melos-latest/getting-started) installed.

1. `cd demos/supabase-todolist-drift`
2. `melos prepare`
3. `cp lib/app_config_template.dart lib/app_config.dart`
4. Insert your Supabase and PowerSync project credentials into `lib/app_config.dart` (See instructions below)
5. `flutter run`

# Set up Supabase Project

Detailed instructions for integrating PowerSync with Supabase can be found in [the integration guide](https://docs.powersync.com/integration-guides/supabase). Below are the main steps required to get this demo running.

Create a new Supabase project, and paste an run the contents of [database.sql](./database.sql) in the Supabase SQL editor.

It does the following:

1. Create `lists` and `todos` tables.
2. Create a publication called `powersync` for `lists` and `todos`.
3. Enable row level security, allowing users to only view and edit their own data.
4. Create a trigger to populate some sample data when an user registers.

# Set up PowerSync Instance

Create a new PowerSync instance, connecting to the database of the Supabase project.

Then deploy the following sync rules:

```yaml
bucket_definitions:
  user_lists:
    # Separate bucket per todo list
    parameters: select id as list_id from lists where owner_id = request.user_id()
    data:
      - select * from lists where id = bucket.list_id
      - select * from todos where list_id = bucket.list_id
```

# Configure the app

Insert the credentials of your new Supabase and PowerSync projects into `lib/app_config.dart`

# Drift

The `database.g.dart` file containing the \_$AppDatabase class has to be generated if there are changes made to the `database.dart` file.

- `dart run build_runner build` generates all the required code once.
- `dart run build_runner build -d` deletes previously generated files and generates the required code once.
- `dart run build_runner watch` watches for changes in your sources and generates code with incremental rebuilds. This is better for development.
