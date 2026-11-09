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
    <main>
      <h1>VelaSupport</h1>
      <ul>
        {categories.map((c) => (
          <li key={c.id}>{c.name}</li>
        ))}
      </ul>
    </main>
  )
}
