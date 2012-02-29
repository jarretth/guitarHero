//
//  soundCallback.c
//  guitarHero
//
//  Created by Jarrett Hawrylak on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "soundCallback.h"
#import "guitarSoundObject.h"

void audioCallback( void                 *inUserData,
                  AudioQueueRef         inAQ,
                  AudioQueueBufferRef   inBuffer)
{
    guitarSoundObject *gso = (guitarSoundObject*)inUserData;
    [gso audioCallback:inAQ buffer:inBuffer];
    return;
}