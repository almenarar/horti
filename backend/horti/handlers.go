package main

import (
	"encoding/json"
	"errors"
	"io/ioutil"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

//curl -XPOST localhost:8000/products -d '{"Name":"Melancia","Price":9.99,"Photo":"foobar","Manufacturer":"Joana","ExpirationDate":"2018-09-22T19:42:31-05:00"}'

func ProductHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	scope, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	switch req.Method {
	case http.MethodGet:
		products, err := GetAllProducts()
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		for _, product := range products {
			for _, batch := range product.Batch {
				//print(time.Since(batch.CreatedAt).String())
				days, _ := time.ParseDuration(time.Since(batch.CreatedAt).String())
				if int32(days.Hours()/24) > product.DaysToExpirate {
					data := map[string]interface{}{"Expirated": true}
					batch.Update(data)
					batch.Delete(batch.ID.String())
				}
			}
		}

		response, err := json.Marshal(products)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write(response)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodPost:
		if scope[1] == "seller" {
			err = errors.New("Not enough permissions")
			http.Error(w, err.Error(), http.StatusUnauthorized)
			return
		}

		body, err := ioutil.ReadAll(req.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var product Product
		if err := json.Unmarshal(body, &product); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		result := product.Create()
		if !result {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}
}

func SingleProductHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	scope, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	switch req.Method {
	case http.MethodGet:
		vars := mux.Vars(req)
		product, err := GetProductByID(vars["ID"])
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		response, err := json.Marshal(product)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write(response)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodDelete:
		if scope[1] == "seller" {
			err = errors.New("Not enough permissions")
			http.Error(w, err.Error(), http.StatusUnauthorized)
			return
		}

		vars := mux.Vars(req)
		product := Product{}
		result := product.Delete(vars["ID"])

		if !result {
			http.Error(w, "", http.StatusInternalServerError)
			return
		}

		_, err := w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodPut:
		if scope[1] == "seller" {
			err = errors.New("Not enough permissions")
			http.Error(w, err.Error(), http.StatusUnauthorized)
			return
		}

		body, err := ioutil.ReadAll(req.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var data map[string]interface{}
		if err := json.Unmarshal(body, &data); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		vars := mux.Vars(req)
		product, err := GetProductByID(vars["ID"])
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		result := product.Update(data)
		if !result {
			http.Error(w, "", http.StatusInternalServerError)
			return
		}

		_, err = w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}
}

func BatchHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	scope, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	switch req.Method {
	case http.MethodGet:
		batches, err := GetAllBatches()
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		for _, batch := range batches {
			if batch.FinalAmount <= 0 {
				batch.Delete(batch.ID.String())
			}
		}

		response, err := json.Marshal(batches)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write(response)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	case http.MethodPost:
		if scope[1] == "seller" {
			err = errors.New("Not enough permissions")
			http.Error(w, err.Error(), http.StatusUnauthorized)
			return
		}

		body, err := ioutil.ReadAll(req.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var batch Batch
		if err := json.Unmarshal(body, &batch); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		result := batch.Create()
		if !result {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}
}

func SingleBatchHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	scope, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	switch req.Method {
	case http.MethodGet:
		vars := mux.Vars(req)
		batch, err := GetBatchesByID(vars["ID"])
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		response, err := json.Marshal(batch)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write(response)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodDelete:
		if scope[1] == "seller" {
			err = errors.New("Not enough permissions")
			http.Error(w, err.Error(), http.StatusUnauthorized)
			return
		}

		vars := mux.Vars(req)
		batch := Batch{}
		result := batch.Delete(vars["ID"])

		if !result {
			http.Error(w, "", http.StatusInternalServerError)
			return
		}

		_, err := w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodPut:
		if scope[1] == "seller" {
			err = errors.New("Not enough permissions")
			http.Error(w, err.Error(), http.StatusUnauthorized)
			return
		}

		body, err := ioutil.ReadAll(req.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var data map[string]interface{}
		if err := json.Unmarshal(body, &data); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		vars := mux.Vars(req)
		batch, err := GetBatchesByID(vars["ID"])
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		result := batch.Update(data)
		if !result {
			http.Error(w, "", http.StatusInternalServerError)
			return
		}

		_, err = w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}
}

func SalesHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	_, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	switch req.Method {
	case http.MethodGet:
		sales, err := GetAllSales()
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		response, err := json.Marshal(sales)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write(response)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodPost:
		body, err := ioutil.ReadAll(req.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var sales Sales
		if err := json.Unmarshal(body, &sales); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		result := sales.Create()
		if !result {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write([]byte(sales.ID.String()))
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}
}

func SingleSalesHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	_, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	switch req.Method {
	case http.MethodGet:
		vars := mux.Vars(req)
		sales, err := GetSalesByID(vars["ID"])
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		response, err := json.Marshal(sales)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write(response)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodDelete:
		vars := mux.Vars(req)
		sales := Sales{}
		result := sales.Delete(vars["ID"])

		if !result {
			http.Error(w, "", http.StatusInternalServerError)
			return
		}

		_, err := w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodPut:
		body, err := ioutil.ReadAll(req.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var data map[string]interface{}
		if err := json.Unmarshal(body, &data); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		vars := mux.Vars(req)
		sales, err := GetSalesByID(vars["ID"])
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		result := sales.Update(data)
		if !result {
			http.Error(w, "", http.StatusInternalServerError)
			return
		}

		_, err = w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}
}

func SoldProductsHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	_, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	switch req.Method {
	case http.MethodGet:
		soldProducts, err := GetAllSoldProducts()
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		response, err := json.Marshal(soldProducts)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write(response)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodPost:
		body, err := ioutil.ReadAll(req.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var soldProducts SoldProducts
		if err := json.Unmarshal(body, &soldProducts); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var batch Batch
		batch, err = GetBatchesByID(soldProducts.BatchID.String())
		data := map[string]interface{}{"FinalAmount": batch.FinalAmount - soldProducts.Amount}
		batch.Update(data)

		result := soldProducts.Create()
		if !result {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}
}

func SingleSoldProductsHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	_, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	switch req.Method {
	case http.MethodGet:
		vars := mux.Vars(req)
		soldProducts, err := GetSoldProductsByID(vars["ID"])
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		response, err := json.Marshal(soldProducts)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write(response)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodDelete:
		vars := mux.Vars(req)
		soldProducts := SoldProducts{}
		result := soldProducts.Delete(vars["ID"])

		if !result {
			http.Error(w, "", http.StatusInternalServerError)
			return
		}

		_, err := w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

	case http.MethodPut:
		body, err := ioutil.ReadAll(req.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var data map[string]interface{}
		if err := json.Unmarshal(body, &data); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		vars := mux.Vars(req)
		soldProducts, err := GetSoldProductsByID(vars["ID"])
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		result := soldProducts.Update(data)
		if !result {
			http.Error(w, "", http.StatusInternalServerError)
			return
		}

		_, err = w.Write([]byte{'D', 'o', 'n', 'e', '!'})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}
}
