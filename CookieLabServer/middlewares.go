package main

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"time"
)

func simulateDelayMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		time.Sleep(1 * time.Second)
		c.Next()
	}
}

func authMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		token, err := c.Cookie(sessionCookieName)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			return
		}

		if !sessionStore.hasValidSession(token) {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			return
		}

		c.Next()
	}
}
