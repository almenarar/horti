package main

import (
	"fmt"
	"horti/db"
)

func (p *Product) Create() bool {
	return CreateInDB(p)
}

func (p Product) Delete(ID string) bool {
	return DeleteInDB(p, ID)
}

func (p *Product) Update(data map[string]interface{}) bool {
	return UpdateInDB(p, data)
}

func GetAllProducts() (data []Product, err error) {
	db := db.GetConnection()

	if err := db.Model(&data).Preload("Batch").Find(&data).Error; err != nil {
		fmt.Println(err)
		return data, err
	}
	return data, err
}

func GetProductByID(ID string) (data Product, err error) {
	db := db.GetConnection()
	if err := db.Model(&data).Preload("Batch").Find(&data, "ID = ?", ID).Error; err != nil {
		fmt.Println(err)
		return data, err
	}
	return data, err
}
