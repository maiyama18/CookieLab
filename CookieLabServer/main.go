package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.Use(simulateDelayMiddleware())

	r.POST("/login", loginHandler)
	r.GET("/message", authMiddleware(), messageHandler)
	r.POST("/logout", authMiddleware(), logoutHandler)

	err := r.Run(":8080")
	if err != nil {
		panic(err)
	}
}
