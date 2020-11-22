package db

import (
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var cn *gorm.DB
var err error

func init() {
	dsn := os.Getenv("DATABASE_URL")
	cn, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}
}

func GetConnection() *gorm.DB {
	return cn
}
