//
//  CAStreamFormatTester.m
//  CAStreamFormatTester
//
//  Created by Xiao Quan on 12/12/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        AudioFileTypeAndFormatID fileTypeAndFormat;
        fileTypeAndFormat.mFileType = kAudioFileAIFFType;
        fileTypeAndFormat.mFormatID = kAudioFormatLinearPCM;
        
        OSStatus audioErr = noErr;
        UInt32 infoSize = 0;
        
        audioErr = AudioFileGetGlobalInfoSize
        (kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat,
         sizeof (fileTypeAndFormat),
         &fileTypeAndFormat,
         &infoSize);
        
        assert(audioErr == noErr);
        
        AudioStreamBasicDescription *asbds = malloc(infoSize);
        audioErr = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat,
                                          sizeof (fileTypeAndFormat),
                                          &fileTypeAndFormat,
                                          &infoSize,
                                          asbds);
        assert(audioErr == noErr);
        
        int asbdCount = infoSize / sizeof(AudioStreamBasicDescription);
        
        for (int i = 0; i < asbdCount; i++) {
            UInt32 format4cc = CFSwapInt32BigToHost(asbds[i].mFormatID);
            
            NSLog(@"%d: mFormatId: %4.4s, mFormatFlags: %d, mBitsPerChannel: %d",
                  i,
                  (char*) &format4cc,
//                  (char *) &asbds[i].mFormatID,
                  asbds[i].mFormatFlags,
                  asbds[i].mBitsPerChannel);
        }
        
        free(asbds);
    }
    return 0;
}
