package main

import (
	"fmt"
	"horti/db"
)

func (p *Sales) Create() bool {
	return CreateInDB(p)
}

func (p Sales) Delete(ID string) bool {
	return DeleteInDB(p, ID)
}

func (p *Sales) Update(data map[string]interface{}) bool {
	return UpdateInDB(p, data)
}

func GetAllSales() (data []Sales, err error) {
	db := db.GetConnection()
	if err := db.Model(&data).Preload("SoldProducts").Find(&data).Error; err != nil {
		fmt.Println(err)
		return data, err
	}
	return data, err
}

func GetSalesByID(ID string) (data Sales, err error) {
	db := db.GetConnection()

	if err := db.Model(&data).Preload("SoldProducts").Find(&data, "ID = ?", ID).Error; err != nil {
		//if err := db.First(&data, "ID = ?", ID).Error; err != nil {
		fmt.Println(err)
		return data, err
	}
	return data, err
}
