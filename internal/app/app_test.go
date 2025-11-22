package app

import (
	"testing"
)

func TestRun(t *testing.T) {
	err := Run()
	if err != nil {
		t.Errorf("Run() returned an error: %v", err)
	}
}
