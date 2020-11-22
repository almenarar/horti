package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/auth", AuthHandler)
	r.HandleFunc("/me", MeHandler)
	r.HandleFunc("/user", UserHandler)
	r.HandleFunc("/user/{ID}", SingleUserHandler)
	r.HandleFunc("/products", ProductHandler)
	r.HandleFunc("/products/{ID}", SingleProductHandler)
	r.HandleFunc("/batches", BatchHandler)
	r.HandleFunc("/batches/{ID}", SingleBatchHandler)
	r.HandleFunc("/sales", SalesHandler)
	r.HandleFunc("/sales/{ID}", SingleSalesHandler)
	r.HandleFunc("/sold-products", SoldProductsHandler)
	r.HandleFunc("/sold-products/{ID}", SingleSoldProductsHandler)
	migrate()
	log.Fatal(http.ListenAndServe("localhost:8000", r))
}
