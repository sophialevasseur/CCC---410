type Category = { id: string; name: string }

export default async function Home() {
  let categories: Category[] = []
  try {
    const res = await fetch(`${process.env.API_URL}/api/categories`, {
      cache: 'no-store',
    })
    if (!res.ok) return <p>Could not load categories ({res.status})</p>
    categories = await res.json()
  } catch {
    return <p>Could not reach the API. Is the Go server running?</p>
  }

      return (
    <main className="min-h-screen bg-secondary text-slate-900">

      <section className="mx-auto max-w-4xl px-6 py-10">
        <h2 className="mb-6 text-xl font-semibold text-tertiary">
          Browse by category
        </h2>
        <ul className="grid grid-cols-2 gap-4 sm:grid-cols-3">
          {categories.map((c) => (
            <li
              key={c.id}
              className="rounded-lg border-b-4 border-primary bg-white p-4 text-center font-medium text-slate-800 shadow-sm transition hover:shadow-md"
            >
              {c.name}
            </li>
          ))}
        </ul>
      </section>
    </main>
  )
}
