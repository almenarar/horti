package main

import (
	"fmt"
	"horti/db"
)

func (p *SoldProducts) Create() bool {
	return CreateInDB(p)
}

func (p SoldProducts) Delete(ID string) bool {
	return DeleteInDB(p, ID)
}

func (p *SoldProducts) Update(data map[string]interface{}) bool {
	return UpdateInDB(p, data)
}

func GetAllSoldProducts() (data []SoldProducts, err error) {
	db := db.GetConnection()
	if err := db.Select("ID", "BatchID", "Amount", "SalesID", "CreatedAt").Find(&data).Error; err != nil {
		fmt.Println(err)
		return data, err
	}
	return data, err
}

func GetSoldProductsByID(ID string) (data SoldProducts, err error) {
	db := db.GetConnection()
	if err := db.First(&data, "ID = ?", ID).Error; err != nil {
		fmt.Println(err)
		return data, err
	}
	return data, err
}
