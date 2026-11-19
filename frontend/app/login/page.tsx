'use client'

import Link from 'next/link'

export default function LoginPage() {
  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    // Not connected yet: this will call the Go API once login exists
  }

  return (
    <main className="flex flex-1 items-center justify-center bg-secondary px-6 py-10">
      <form
        onSubmit={handleSubmit}
        className="w-full max-w-sm rounded-lg border-b-4 border-primary bg-white p-8 shadow-md"
      >
        <h1 className="text-2xl font-bold text-tertiary">Log in</h1>
        <p className="mb-6 mt-1 text-sm text-slate-600">
          Welcome back to VelaSupport
        </p>

        <label htmlFor="email" className="mb-1 block text-sm font-medium text-slate-700">
          Email
        </label>
        <input
          id="email"
          type="email"
          autoComplete="email"
          required
          placeholder="name@example.com"
          className="mb-4 w-full rounded-md border border-slate-300 px-3 py-2 focus:border-tertiary focus:outline-none focus:ring-2 focus:ring-tertiary/30"
        />

        <label htmlFor="password" className="mb-1 block text-sm font-medium text-slate-700">
          Password
        </label>
        <input
          id="password"
          type="password"
          autoComplete="current-password"
          required
          placeholder="Enter your password"
          className="mb-2 w-full rounded-md border border-slate-300 px-3 py-2 focus:border-tertiary focus:outline-none focus:ring-2 focus:ring-tertiary/30"
        />
        <p className="mb-6 text-sm">
          <Link href="/forgot-password" className="text-tertiary underline">
            Forgot password?
          </Link>
        </p>

        <button
          type="submit"
          className="w-full rounded-md bg-tertiary py-2 font-semibold text-white transition hover:opacity-90"
        >
          Log in
        </button>

        <p className="mt-4 text-center text-sm text-slate-600">
          New here?{' '}
          <Link href="/signup" className="font-medium text-tertiary underline">
            Create an account
          </Link>
        </p>
      </form>
    </main>
  )
}