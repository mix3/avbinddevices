// MIT License
//
// Copyright (c) 2019-2020 Pion
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

package avbinddevices

// #cgo CFLAGS: -x objective-c
// #cgo LDFLAGS: -framework AVFoundation -framework Foundation
// #include "avbinddevices.h"
import "C"
import (
	"fmt"
	"unsafe"
)

type MediaType C.AVBindMediaType

const (
	Video = MediaType(C.AVBindMediaTypeVideo)
	Audio = MediaType(C.AVBindMediaTypeAudio)
)

// Device represents a metadata that later can be used to retrieve back the
// underlying device given by AVFoundation
type Device struct {
	// UID is a unique identifier for a device
	UID     string
	LName   string
	cDevice C.AVBindDevice
}

// Devices uses AVFoundation to query a list of devices based on the media type
func Devices(mediaType MediaType) ([]Device, error) {
	var cDevicesPtr C.PAVBindDevice
	var cDevicesLen C.int

	status := C.AVBindDevices(C.AVBindMediaType(mediaType), &cDevicesPtr, &cDevicesLen)
	if status != nil {
		return nil, fmt.Errorf("%s", C.GoString(status))
	}

	// https://github.com/golang/go/wiki/cgo#turning-c-arrays-into-go-slices
	cDevices := (*[1 << 28]C.AVBindDevice)(unsafe.Pointer(cDevicesPtr))[:cDevicesLen:cDevicesLen]
	devices := make([]Device, cDevicesLen)

	for i := range devices {
		devices[i].UID = C.GoString(&cDevices[i].uid[0])
		devices[i].LName = C.GoString(&cDevices[i].lname[0])
		devices[i].cDevice = cDevices[i]
	}

	return devices, nil
}
