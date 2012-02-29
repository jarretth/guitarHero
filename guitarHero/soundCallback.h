//
//  soundCallback.h
//  guitarHero
//
//  Created by Jarrett Hawrylak on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#ifndef guitarHero_soundCallback_h
#define guitarHero_soundCallback_h

#import <AudioToolbox/AudioToolbox.h>

void audioCallback(void *                  inUserData,
                   AudioQueueRef           inAQ,
                   AudioQueueBufferRef     inBuffer);

#endif
