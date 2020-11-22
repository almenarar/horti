package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gorilla/mux"
	"golang.org/x/crypto/bcrypt"
)

type Claims struct {
	jwt.StandardClaims
	Role string
}

func hashAndSalt(pwd string) string {
	hash, err := bcrypt.GenerateFromPassword([]byte(pwd), 4)
	if err != nil {
		fmt.Println(err)
	}

	return string(hash)
}

func comparePasswords(hashedPwd string, pwd string) bool {
	byteHash := []byte(hashedPwd)
	err := bcrypt.CompareHashAndPassword(byteHash, []byte(pwd))
	if err != nil {
		log.Println(err)
		return false
	}

	return true
}

func identify(token string) (data [2]string, err error) {
	newToken, err := jwt.ParseWithClaims(token, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte("AllYourBase"), nil
	})
	if claims, ok := newToken.Claims.(*Claims); ok && newToken.Valid {
		data[0] = claims.StandardClaims.Issuer
		data[1] = claims.Role
	}
	return
}

func MeHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	scope, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	response := fmt.Sprintf("%s:%s", scope[0], scope[1])
	_, err = w.Write([]byte(response))
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return

	}

}

func AuthHandler(w http.ResponseWriter, req *http.Request) {
	switch req.Method {
	case http.MethodPost:
		body, err := ioutil.ReadAll(req.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var data map[string]string
		if err := json.Unmarshal(body, &data); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		users, err := GetAllUsers()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		for _, user := range users {
			if user.Name == data["Name"] && comparePasswords(user.Password, data["Password"]) {

				claims := Claims{
					jwt.StandardClaims{
						ExpiresAt: time.Now().Unix() + (60 * 60 * 24),
						Issuer:    user.Name,
					},
					user.Role,
				}
				token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
				ss, err := token.SignedString([]byte("AllYourBase"))
				if err != nil {
					http.Error(w, err.Error(), http.StatusInternalServerError)
					return
				}
				_, err = w.Write([]byte(ss))
				if err != nil {
					http.Error(w, err.Error(), http.StatusInternalServerError)
					return
				}

				att := map[string]interface{}{"LastLogin": time.Now()}
				user.Update(att)
				return
			}
		}

		err = errors.New("Name or Password incorrect!")
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

	}
}

func UserHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	scope, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if scope[1] != "admin" {
		err = errors.New("Not enough permissions")
		http.Error(w, err.Error(), http.StatusUnauthorized)
		return
	}

	switch req.Method {
	case http.MethodGet:
		users, err := GetAllUsers()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		response, err := json.Marshal(users)
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

		var user User
		if err := json.Unmarshal(body, &user); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		result := user.Create()
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

func SingleUserHandler(w http.ResponseWriter, req *http.Request) {
	token := req.Header.Get("Authorization")
	scope, err := identify(token)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if scope[1] != "admin" {
		err = errors.New("Not enough permissions")
		http.Error(w, err.Error(), http.StatusUnauthorized)
		return
	}

	switch req.Method {
	case http.MethodGet:
		vars := mux.Vars(req)
		user, err := GetUserByID(vars["ID"])
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		response, err := json.Marshal(user)
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
		user := User{}
		result := user.Delete(vars["ID"])

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
		user, err := GetUserByID(vars["ID"])
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		result := user.Update(data)
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
