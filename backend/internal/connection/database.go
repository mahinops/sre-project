// Package connection provides functions for connecting to a MySQL database.
package connection

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB

// InitializeDB initializes the database connection.
func InitializeDB(username, password, host, port, dbName string) error {
	dataSourceName := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", username, password, host, port, dbName)
	var err error
	db, err = sql.Open("mysql", dataSourceName)
	if err != nil {
		return err
	}

	err = db.Ping()
	if err != nil {
		return err
	}

	log.Println("Connected to the database")
	return nil
}

// GetDB returns the database connection instance.
func GetDB() *sql.DB {
	return db
}

// CloseDB closes the database connection.
func CloseDB() error {
	if db != nil {
		err := db.Close()
		if err != nil {
			return err
		}
		log.Println("Database connection closed")
	}
	return nil
}
