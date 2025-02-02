package main

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

const (
	validUsername = "m@example.com"
	validPassword = "password1"
)

func loginHandler(c *gin.Context) {
	var credential struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}

	if err := c.ShouldBindJSON(&credential); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	if credential.Username != validUsername || credential.Password != validPassword {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	sessionToken, maxAge := sessionStore.createSession()

	c.SetCookie(sessionCookieName, sessionToken, int(maxAge.Seconds()), "/", "localhost", false, false)
	c.Status(http.StatusOK)
}

func helloHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "Hello, world!"})
}

func logoutHandler(c *gin.Context) {
	token, _ := c.Cookie(sessionCookieName)

	sessionStore.deleteSession(token)

	c.SetCookie(sessionCookieName, "", -1, "/", "localhost", false, false)
	c.Status(http.StatusOK)
}
