package main

import (
	"fmt"
	"horti/db"
)

func (p *Batch) Create() bool {
	return CreateInDB(p)
}

func (p Batch) Delete(ID string) bool {
	return DeleteInDB(p, ID)
}

func (p *Batch) Update(data map[string]interface{}) bool {
	return UpdateInDB(p, data)
}

func GetAllBatches() (data []Batch, err error) {
	db := db.GetConnection()
	if err := db.Select("ID", "CreatedAt", "ProductID", "TotalAmount", "FinalAmount", "Expirated").Find(&data).Error; err != nil {
		fmt.Println(err)
		return data, err
	}
	return data, err
}

func GetBatchesByID(ID string) (data Batch, err error) {
	db := db.GetConnection()
	if err := db.Model(&data).Preload("SoldProducts").Find(&data, "ID = ?", ID).Error; err != nil {
		fmt.Println(err)
		return data, err
	}
	return data, err
}
