package main

import (
	"fmt"
	"horti/db"
)

func (p *User) Create() bool {
	p.Password = hashAndSalt(p.Password)
	return CreateInDB(p)
}

func (p User) Delete(ID string) bool {
	return DeleteInDB(p, ID)
}

func (p *User) Update(data map[string]interface{}) bool {
	return UpdateInDB(p, data)
}

func GetAllUsers() (data []User, err error) {
	db := db.GetConnection()

	if err := db.Select("ID", "Name", "Password", "Role", "CreatedAt", "LastLogin", "Email", "Phone").Find(&data).Error; err != nil {
		fmt.Println(err)
		return data, err
	}
	return data, err
}

func GetUserByID(ID string) (data User, err error) {
	db := db.GetConnection()
	if err := db.Model(&data).Find(&data, "ID = ?", ID).Error; err != nil {
		fmt.Println(err)
		return data, err
	}
	return data, err
}
