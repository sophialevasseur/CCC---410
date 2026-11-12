import Link from "next/link"

export default function Header() {
    return (
        <header className="flex items-center justify-between bg-primary px-6 py-4 shadow">
            <h1 className="text-2xl text-tertiary font-bold">VelaSupports</h1>
            <nav className="flex items-center gap-3">
                <Link href="/login" className="rounded-md border-2 border-tertiary px-4 py-2 font-semibold text-tertiary transition hover:bg-tertiary hover:text-white"
                >
                    Log In
                </Link>
                <Link href="/signup" className="rounded-md bg-tertiary px-4 py-2 font-semibold text-white transition hover:opacity-90"
                >
                    Sign Up
                </Link>
            </nav>
        </header>
    )
}