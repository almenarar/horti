package main

import (
	"horti/db"
	"time"

	uuid "github.com/satori/go.uuid"
	"gorm.io/gorm"
)

type Base struct {
	ID        uuid.UUID      `gorm:"type:uuid;primary_key;"`
	CreatedAt time.Time      `json:",omitempty"`
	UpdatedAt time.Time      `json:",omitempty"`
	DeletedAt gorm.DeletedAt `json:",omitempty"`
}

type User struct {
	Base
	Name      string
	Password  string
	Role      string
	Email     string
	Phone     string
	LastLogin time.Time
}

type Product struct {
	Base
	Name           string  `json:",omitempty"`
	Price          float32 `json:",omitempty"`
	DaysToExpirate int32   `json:",omitempty"`
	Manufacturer   string  `json:",omitempty"`
	Batch          []Batch `json:",omitempty"`
}

type Batch struct {
	Base
	ProductID    uuid.UUID `gorm:"type:uuid;column:product_foreign_key;not null;"`
	TotalAmount  int32
	FinalAmount  int32
	Expirated    bool
	SoldProducts []SoldProducts `json:",omitempty"`
}

type Sales struct {
	Base
	TotalPrice   float32        `json:",omitempty"`
	Paynment     string         `json:",omitempty"`
	SoldProducts []SoldProducts `json:",omitempty"`
}

type SoldProducts struct {
	Base    `json:",omitempty"`
	BatchID uuid.UUID `gorm:"type:uuid;column:batch_foreign_key;not null;"`
	Amount  int32     `json:",omitempty"`
	SalesID uuid.UUID `gorm:"type:uuid;column:sales_foreign_key;not null;"`
}

func migrate() {
	db := db.GetConnection()
	db.AutoMigrate(&Product{})
	db.AutoMigrate(&Batch{})
	db.AutoMigrate(&Sales{})
	db.AutoMigrate(&SoldProducts{})
	db.AutoMigrate(&User{})
}

func (base *Base) BeforeCreate(tx *gorm.DB) (err error) {
	UUID, err := uuid.NewV4()
	if err != nil {
		return
	}
	base.ID = UUID
	return
}
