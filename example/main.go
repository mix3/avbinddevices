package main

import (
	"log"

	"github.com/mix3/avbinddevices"
)

func main() {
	devices, err := avbinddevices.Devices(avbinddevices.Video)
	if err != nil {
		log.Fatal(err)
	}
	for i, device := range devices {
		log.Printf("[%d] %s", i, device.LName)
	}
}
