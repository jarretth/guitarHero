//
//  sinWaveGen.h
//  guitarHero
//
//  Created by Jarrett Hawrylak on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ATTACK_DUR 1000

@interface sinWaveGen : NSObject
{
    NSNumber *frequency;
}

@property (copy) NSNumber *frequency;

-(id)initWithFrequency:(NSNumber *)frequency;
-(float)nextValue;
-(void)attack;

@end


double angleForFreq(double freq);