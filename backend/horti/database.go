package main

import (
	"fmt"
	"horti/db"
)

func CreateInDB(element interface{}) bool {
	db := db.GetConnection()
	result := db.Create(element)

	if result.Error != nil {
		fmt.Println(result.Error)
		return false
	}
	return true
}

func DeleteInDB(element interface{}, ID string) bool {
	db := db.GetConnection()
	result := db.Delete(element, "ID = ?", ID)

	if result.Error != nil {
		fmt.Println(result.Error)
		return false
	}
	return true
}

func UpdateInDB(element interface{}, data map[string]interface{}) bool {
	db := db.GetConnection()
	if val, ok := data["Password"]; ok {
		data["Password"] = hashAndSalt(fmt.Sprintf("%v", val))
	}
	//https://stackoverflow.com/questions/18041334/convert-interface-to-int
	if _, ok := data["DaysToExpirate"]; ok {
		data["DaysToExpirate"] = int(data["DaysToExpirate"].(float64))
	}
	result := db.Model(element).Updates(data)

	if result.Error != nil {
		fmt.Println(result.Error)
		return false
	}
	return true
}
