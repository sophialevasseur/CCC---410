import { useEffect, useState } from 'react'

export default function App() {
  const [categories, setCategories] = useState([])
  const [error, setError] = useState(null)

  useEffect(() => {
    fetch(`${import.meta.env.VITE_API_URL}/api/categories`)
      .then(r => (r.ok ? r.json() : Promise.reject(r.status)))
      .then(setCategories)
      .catch(e => setError(String(e)))
  }, [])

  if (error) return <p>Could not load categories ({error})</p>

  return (
    <div>
      <h1>VelaSupport</h1>
      <ul>
        {categories.map(c => <li key={c.id}>{c.name}</li>)}
      </ul>
    </div>
  )
}
