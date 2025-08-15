# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Setup and Dependencies
- `mix setup` - Install and setup dependencies (includes Ecto setup and asset building)
- `mix deps.get` - Fetch dependencies only

### Database Operations
- `mix ecto.setup` - Create database, run migrations, and seed data
- `mix ecto.reset` - Drop and recreate database
- `mix ecto.create` - Create database
- `mix ecto.migrate` - Run migrations

### Server Operations
- `mix phx.server` - Start Phoenix server (http://localhost:4000)
- `iex -S mix phx.server` - Start server in interactive Elixir shell

### Asset Management
- `mix assets.setup` - Install Tailwind and ESBuild if missing
- `mix assets.build` - Build assets for development
- `mix assets.deploy` - Build and minify assets for production

### Testing and Quality
- `mix test` - Run all tests (sets up test database automatically)
- `mix test test/path/to/file_test.exs` - Run specific test file
- `mix test --failed` - Run only previously failed tests
- `mix precommit` - Full quality check (compile with warnings as errors, format, test)

## Project Architecture

This is a Phoenix 1.8 web application for managing developer commands/snippets with user authentication.

### Core Domain Structure

**Commands System**: The main feature allowing users to store and manage command snippets
- `DevHelper.Commands` - Commands context (business logic)
- `DevHelper.Commands.Command` - Command schema with title, content, description, tags
- Commands are scoped per user with PubSub notifications for real-time updates

**Authentication**: Built with phx.gen.auth providing complete user management
- `DevHelper.Accounts` - User management context with email/password and magic link auth
- `DevHelper.Accounts.Scope` - User scoping mechanism for multi-tenant features
- Magic link authentication support alongside traditional email/password

### Web Layer Organization

**Router**: Structured with authentication-aware scopes
- Public routes (no auth required)
- `live_session :current_user` - Routes that work with/without auth
- `live_session :require_authenticated_user` - Authenticated-only routes

**LiveViews**: 
- Command management with real-time updates via streams
- User authentication flows (registration, login, settings)
- Uses `@current_scope.user` pattern (not `@current_user`)

**Components**: Modern Phoenix 1.8 structure
- `core_components.ex` - Shared UI components
- `layouts.ex` - App-wide layout with flash handling

### Key Patterns

**Scoped Operations**: All business operations use `Scope` struct for user context
```elixir
# Always pass scope for user-scoped operations
Commands.list_commands(scope)
Commands.create_command(scope, attrs)
```

**Real-time Updates**: PubSub integration for live command updates
- Subscribe to user-scoped command changes
- Broadcast create/update/delete events

**Asset Pipeline**: Tailwind CSS + ESBuild for modern frontend tooling

## Important Guidelines

- Use `mix precommit` before committing to ensure code quality
- Use `:req` library for HTTP requests (already included)
- Commands have unique titles globally (unique constraint)
- All user-scoped operations require `Scope` struct parameter
- LiveViews must use `<Layouts.app flash={@flash} current_scope={@current_scope}>` wrapper
- Access current user via `@current_scope.user`, never `@current_user`