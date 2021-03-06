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

#pragma once

#include <stddef.h>

#define MAX_DEVICES                      8
#define MAX_DEVICE_UID_CHARS             64
#define MAX_DEVICE_LNAME_CHARS           64

typedef const char* STATUS;
static STATUS STATUS_OK                       = (STATUS) NULL;
static STATUS STATUS_NULL_ARG                 = (STATUS) "One of the arguments was null";
static STATUS STATUS_UNSUPPORTED_MEDIA_TYPE   = (STATUS) "Unsupported media type";

typedef enum AVBindMediaType {
    AVBindMediaTypeVideo,
    AVBindMediaTypeAudio,
} AVBindMediaType;

typedef struct {
    char uid[MAX_DEVICE_UID_CHARS + 1];
    char lname[MAX_DEVICE_LNAME_CHARS + 1];
} AVBindDevice, *PAVBindDevice;

// AVBindDevices returns a list of AVBindDevices. The result array is pointing to a static
// memory. The caller is expected to not hold on to the address for a long time and make a copy.
// Everytime this function gets called, the array will be overwritten and the memory will be reused.
STATUS AVBindDevices(AVBindMediaType, PAVBindDevice*, int*);
