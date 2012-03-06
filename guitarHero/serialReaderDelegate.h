//
//  serialReaderDelegate.h
//  guitarHero
//
//  Created by Jarrett Hawrylak on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol serialReaderDelegate <NSObject>
-(void)strum:(NSArray*)notes;
-(void)noteRelease;
-(void)toggleDistortion;
@end
