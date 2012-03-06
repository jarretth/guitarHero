//
//  ghSerialReader.h
//  guitarHero
//
//  Created by Jarrett Hawrylak on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import <stdio.h>
#import <string.h>
#import <unistd.h>
#import <fcntl.h>
#import <sys/ioctl.h>
#import <errno.h>
#import <paths.h>
#import <termios.h>
#import <sysexits.h>
#import <sys/param.h>
#import <sys/select.h>
#import <sys/time.h>
#import <time.h>
#import <AvailabilityMacros.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/serial/IOSerialKeys.h>
#if defined(MAC_OS_X_VERSION_10_3) && (MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_3)
#import <IOKit/serial/ioss.h>
#endif
#import <IOKit/IOBSD.h>
#import <Foundation/Foundation.h>
#import "serialReaderDelegate.h"

@interface ghSerialReader : NSObject {
    int fd;
    struct termios options;
    struct termios origOptions;
    id<serialReaderDelegate> handler;
}

-(void)serialRead:(NSThread*)curThread;
-(id)initWithFile:(NSString*)file andHandler:(id<serialReaderDelegate>)h;
-(void)processCommand:(NSString*)command;

@end
