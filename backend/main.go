package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

type Category struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

func main() {
	pool, err := pgxpool.New(context.Background(), os.Getenv("DATABASE_URL"))
	if err != nil {
		log.Fatal(err)
	}
	defer pool.Close()

	http.HandleFunc("/api/categories", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "http://localhost:5173")

		rows, err := pool.Query(r.Context(), "SELECT id::text, name FROM categories ORDER BY name")
		if err != nil {
			http.Error(w, "db error", http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		cats := []Category{}
		for rows.Next() {
			var c Category
			if err := rows.Scan(&c.ID, &c.Name); err != nil {
				http.Error(w, "db error", http.StatusInternalServerError)
				return
			}
			cats = append(cats, c)
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(cats)
	})

	log.Println("API listening on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
