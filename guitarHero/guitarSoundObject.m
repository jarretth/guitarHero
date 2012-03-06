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
        
        for(int i = 0; i < 5; i++)
        {
            waves[i] = nil;
        }
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
    /*if(started) {
        [self stopSound];
        [self startSound];
    }*/
}

-(void)audioCallback:(AudioQueueRef)inAQ buffer:(AudioQueueBufferRef)inBuffer
{
    //NSLog(@"Callback.\n\tenabledNotes: %@\n\tscale%@",enabledNotes,scale);
    for(int j = 0; j < enabledNotes.count; j++)
    {
        NSNumber *num = (NSNumber*)[enabledNotes objectAtIndex:j];
        if(num.boolValue)
        {
            if(waves[j] == nil)
            {
                if(j < [scale count]) 
                    waves[j] = [[sinWaveGen alloc] initWithFrequency:(NSNumber*)[scale objectAtIndex:j]];
            }
        }
        else
        {
            waves[j] = nil;
        }
    }
    for(int i = 0; i < 100; i++)
    {
        float total = 0.0;
        float div = 1.0;
        for(int j = 0; j < 5; j++)
        {
            if(waves[j] != nil)
            {
                total += [waves[j] nextValue];
                if((div - 1.0) < 0.000002)
                    div += 1.0;
                else
                    div += 0.000001;
            }
        }
        total = (total/div)*distortion;
        if(total >= 1.0) total = 1.0;
        if(total <= -1.0) total = -1.0;
        ((UInt16*)inBuffer->mAudioData)[i] = (UInt16)(total*amplitude);
    }
    inBuffer->mAudioDataByteSize = 200;
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

