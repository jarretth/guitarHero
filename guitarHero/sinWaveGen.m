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
    UInt64 zeroOne;
    UInt64 attack;
}

@synthesize frequency;

- (id)init
{
    self = [super init];
    if (self) {
        index = 0;
        zeroOne = UINT64_MAX;
        attack = 0;
    }
    
    return self;
}

-(id)initWithFrequency:(NSNumber*)freq
{
    [self init];
    self.frequency = freq;
    return self;
}

-(void)attack
{
    attack = ATTACK_DUR;
}

-(float)nextValue
{
    float thisNote = 0.0;
    index++;
    thisNote += (2.9+(attack/ATTACK_DUR)*1.0) * sin(angleForFreq(frequency.floatValue) * index);
    thisNote += (2.5+(attack/ATTACK_DUR)*2.0) * sin(angleForFreq(2.0*frequency.floatValue) * index);
    thisNote += (1.5+(attack/ATTACK_DUR)*2.8) * sin(angleForFreq(3.0*frequency.floatValue) * index);
    thisNote += (1.5+(attack/ATTACK_DUR)*2.5) * sin(angleForFreq(4.0*frequency.floatValue) * index);
    thisNote += (0.0+(attack/ATTACK_DUR)*3.0) * sin(angleForFreq(5.0*frequency.floatValue) * index);
    thisNote += (0.0+(attack/ATTACK_DUR)*2.8) * sin(angleForFreq(6.0*frequency.floatValue) * index);
    if(index == ceilf(8000/(frequency.floatValue)*720.0))
        index = 0;
    if(attack > 0) attack--;
    return (1.2-(attack/ATTACK_DUR)*0.2)*(thisNote / (1.6+(attack/ATTACK_DUR)*14.1));

}

@end

double angleForFreq(double freq)
{
    return (M_PI * 2 * freq) / (8000 * 1.0);
}
