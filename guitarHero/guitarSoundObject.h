//
//  guitarSoundObject.h
//  guitarHero
//
//  Created by Jarrett Hawrylak on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "soundCallback.h"

#define buffer_count 5

@interface guitarSoundObject : NSObject {
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef queue;
    AudioQueueBufferRef buffers[buffer_count];
    
    NSArray *scale;
    NSArray *enabledNotes;
    
    int started;
}

@property (copy) NSArray *scale;
@property (copy) NSArray *enabledNotes;

-(void)setVolume:(float)volume;
-(void)refreshSound;
-(void)startSound;
-(void)stopSound;
-(void)audioCallback:(AudioQueueRef)inAQ buffer:(AudioQueueBufferRef)inBuffer;
@end

double angleForFreq(double freq);