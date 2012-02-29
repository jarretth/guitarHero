//
//  guitarSoundObject.m
//  guitarHero
//
//  Created by Jarrett Hawrylak on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "guitarSoundObject.h"
#include "soundCallback.h"

@implementation guitarSoundObject

@synthesize scale,enabledNotes;

- (id)init
{
    self = [super init];
    if (self) {
        dataFormat.mSampleRate = 8000.0;
        dataFormat.mFormatID = kAudioFormatLinearPCM;
        dataFormat.mFramesPerPacket = 1;
        dataFormat.mChannelsPerFrame = 1;
        dataFormat.mBytesPerFrame = 2;
        dataFormat.mBytesPerPacket = 2;
        dataFormat.mBitsPerChannel = 16;
        dataFormat.mReserved = 0;
        dataFormat.mFormatFlags =   kLinearPCMFormatFlagIsBigEndian     |
                                    kLinearPCMFormatFlagIsSignedInteger |
                                    kLinearPCMFormatFlagIsPacked;
        started = 0;
        
        OSStatus status = AudioQueueNewOutput(&dataFormat,audioCallback,
                                              self,CFRunLoopGetCurrent(),kCFRunLoopCommonModes,0,&queue);
        if(status) { NSLog(@"Audio initialization failed!"); return nil; }
        [self setVolume:1.0];
        for(int i = 0; i < buffer_count; i++)
        {
            status = AudioQueueAllocateBuffer(queue,8000,&buffers[i]);
            if(status) { NSLog(@"Buffer[%d] creation failed!",i); return nil; }
        }
        self.scale = [NSArray array];
        self.enabledNotes = [NSArray array];
    }
    
    return self;
}

-(void)startSound
{
    if(started) return;
    for(int i = 0; i < buffer_count; i++)
    {
        audioCallback(self, queue, buffers[i]);
    }
    OSStatus status = AudioQueueStart(queue,NULL);
    if(status) 
        NSLog(@"Audio start failed!");
    else 
        started = 1;
}

-(void)stopSound
{
    if(!started) return;
    OSStatus result = AudioQueueStop(queue,true);
    if(result)
        NSLog(@"Audio stop failed!");
    else
        started = 0;
}

-(void)setVolume:(float)volume
{
    AudioQueueSetParameter(queue, kAudioQueueParam_Volume, volume);
}

-(void)refreshSound
{
    if(started) {
        [self stopSound];
        [self startSound];
    }
}

-(void)audioCallback:(AudioQueueRef)inAQ buffer:(AudioQueueBufferRef)inBuffer
{
    //NSLog(@"Callback.\n\tenabledNotes: %@\n\tscale%@",enabledNotes,scale);
    for(int i = 0; i < 4000; i++)
    {
        UInt16 total = 0;
        for(int j = 0; j < enabledNotes.count; j++)
        {
            NSNumber *num = (NSNumber*)[enabledNotes objectAtIndex:j];
            if(num.boolValue)
            {
                NSNumber *freq = (NSNumber*)[scale objectAtIndex:j];
                //if(i==0) NSLog(@"putting note for freq %f",freq.floatValue);
                total += (15*sin(angleForFreq(freq.floatValue) * i));
            }
        }
        ((UInt16*)inBuffer->mAudioData)[i] = (UInt16)total;
    }
    inBuffer->mAudioDataByteSize = 8000;
	AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    return;
}

@end

double angleForFreq(double freq)
{
    return (M_PI * 2 * freq) / (8000 * 1.0);
}
