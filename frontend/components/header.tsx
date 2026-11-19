import Link from "next/link"

export default function Header() {
    return (
        <header className="flex items-center justify-between bg-primary px-6 py-4 shadow">
            <Link href="/" className="text-2xl font-bold text-secondary">
                VelaSupports
            </Link>
            <nav className="flex items-center gap-3">
                <Link href="/login" className="rounded-md border-2 border-secondary px-4 py-2 font-semibold text-secondary transition hover:bg-tertiary hover:text-secondary"
                >
                    Log In
                </Link>
                <Link href="/signup" className="rounded-md bg-secondary px-4 py-2 font-semibold text-tertiary transition hover:opacity-90"
                >
                    Sign Up
                </Link>
            </nav>
        </header>
    )
}