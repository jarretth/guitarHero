//
//  sinWaveGen.m
//  guitarHero
//
//  Created by Jarrett Hawrylak on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "sinWaveGen.h"

@implementation sinWaveGen
{
    UInt64 index;
}

@synthesize frequency;

- (id)init
{
    self = [super init];
    if (self) {
        index = 0;
    }
    
    return self;
}

-(id)initWithFrequency:(NSNumber*)freq
{
    [self init];
    self.frequency = freq;
    return self;
}

-(float)nextValue
{
    float thisNote = 0.0;
    index++;
    thisNote += 5.0 * sin(angleForFreq(frequency.floatValue) * index);
    thisNote += 4.0 * sin(angleForFreq(2.0*frequency.floatValue) * index);
    thisNote += 3.0 * sin(angleForFreq(3.0*frequency.floatValue) * index);
    thisNote += 2.0 * sin(angleForFreq(4.0*frequency.floatValue) * index);
    thisNote += 2.0 * sin(angleForFreq(5.0*frequency.floatValue) * index);
    thisNote += sin(angleForFreq(6.0*frequency.floatValue) * index);
    return thisNote / 17.0;

}

@end

double angleForFreq(double freq)
{
    return (M_PI * 2 * freq) / (8000 * 1.0);
}
