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
        self.distortion = false;
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
        float total = 0.0;
        float div = 0.0;
        for(int j = 0; j < enabledNotes.count; j++)
        {
            NSNumber *num = (NSNumber*)[enabledNotes objectAtIndex:j];
            if(num.boolValue)
            {
                div += 1.0;
                float thisNote = 0.0;
                NSNumber *freq = (NSNumber*)[scale objectAtIndex:j];
                //if(i==0) NSLog(@"putting note for freq %f",freq.floatValue);
                thisNote += 5.0 * sin(angleForFreq(freq.floatValue) * i);
                thisNote += 4.0 * sin(angleForFreq(2.0*freq.floatValue) * i);
                thisNote += 3.0 * sin(angleForFreq(3.0*freq.floatValue) * i);
                thisNote += 2.0 * sin(angleForFreq(4.0*freq.floatValue) * i);
                thisNote += 2.0 * sin(angleForFreq(5.0*freq.floatValue) * i);
                thisNote += sin(angleForFreq(6.0*freq.floatValue) * i);
                total += thisNote / 17.0;
            }
        }
        total = (total/div)*distortion;
        if(total >= 1.0) total = 1.0;
        if(total <= -1.0) total = -1.0;
        ((UInt16*)inBuffer->mAudioData)[i] = (UInt16)(total*amplitude);
    }
    inBuffer->mAudioDataByteSize = 8000;
	AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    return;
}

-(void)dealloc
{
    [super dealloc];
    AudioQueueStop(queue,true);
    for(int i = 0; i < buffer_count; i++)
    {
        AudioQueueFreeBuffer(queue, buffers[i]);
        buffers[i] = NULL;
    }
    AudioQueueDispose(queue, true);
    queue = NULL;
}

-(bool)distortion
{
    return distortion > 1.1;
}

-(void)setDistortion:(bool)shouldDistort
{
    distortion = shouldDistort ? 100.0 : 1.0;
}

@end

double angleForFreq(double freq)
{
    return (M_PI * 2 * freq) / (8000 * 1.0);
}
