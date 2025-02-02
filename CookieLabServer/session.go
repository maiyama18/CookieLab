package main

import (
	"github.com/google/uuid"
	"sync"
	"time"
)

const sessionCookieName = "cookielab_session"

type SessionStore struct {
	sessions map[string]time.Time
	mu       sync.RWMutex
}

var sessionStore = &SessionStore{
	sessions: make(map[string]time.Time),
}

func (s *SessionStore) hasValidSession(token string) bool {
	sessionStore.mu.RLock()
	defer sessionStore.mu.RUnlock()

	expiresAt, exists := sessionStore.sessions[token]
	return exists && time.Now().Before(expiresAt)
}

func (s *SessionStore) createSession() (string, time.Duration) {
	s.mu.Lock()
	defer s.mu.Unlock()

	token := uuid.New().String()
	s.sessions[token] = time.Now().Add(24 * time.Hour)
	return token, 24 * time.Hour
}

func (s *SessionStore) deleteSession(token string) {
	s.mu.Lock()
	defer s.mu.Unlock()

	delete(s.sessions, token)
}
