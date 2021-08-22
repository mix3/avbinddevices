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

// Naming Convention (let "name" as an actual variable name):
//   - mName: "name" is a member of an Objective C object
//   - pName: "name" is a C pointer
//   - refName: "name" is an Objective C object reference

#import <AVFoundation/AVFoundation.h>
#import "avbinddevices.h"

#define CHK(condition, status) \
    do { \
        if(!(condition)) { \
            retStatus = status; \
            goto cleanup; \
        } \
    } while(0)

STATUS AVBindDevices(AVBindMediaType mediaType, PAVBindDevice *ppDevices, int *pLen) {
    static AVBindDevice devices[MAX_DEVICES];
    STATUS retStatus = STATUS_OK;
    NSAutoreleasePool *refPool = [[NSAutoreleasePool alloc] init];
    CHK(mediaType == AVBindMediaTypeVideo || mediaType == AVBindMediaTypeAudio, STATUS_UNSUPPORTED_MEDIA_TYPE);
    CHK(ppDevices != NULL && pLen != NULL, STATUS_NULL_ARG);

    PAVBindDevice pDevice;
    AVMediaType _mediaType = mediaType == AVBindMediaTypeVideo ? AVMediaTypeVideo : AVMediaTypeAudio;
    NSArray *refAllTypes = @[
        AVCaptureDeviceTypeBuiltInWideAngleCamera,
        AVCaptureDeviceTypeBuiltInMicrophone,
        AVCaptureDeviceTypeExternalUnknown
    ];
    AVCaptureDeviceDiscoverySession *refSession = [AVCaptureDeviceDiscoverySession
        discoverySessionWithDeviceTypes: refAllTypes
        mediaType: _mediaType
        position: AVCaptureDevicePositionUnspecified];

    int i = 0;
    for (AVCaptureDevice *refDevice in refSession.devices) {
        if (i >= MAX_DEVICES) {
            break;
        }

        pDevice = devices + i;
        strncpy(pDevice->uid, refDevice.uniqueID.UTF8String, MAX_DEVICE_UID_CHARS);
        pDevice->uid[MAX_DEVICE_UID_CHARS] = '\0';
        strncpy(pDevice->lname, refDevice.localizedName.UTF8String, MAX_DEVICE_LNAME_CHARS);
        pDevice->uid[MAX_DEVICE_LNAME_CHARS] = '\0';
        i++;
    }

    *ppDevices = devices;
    *pLen = i;

cleanup:
    [refPool drain];
    return retStatus;
}
