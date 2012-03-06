//
//  ghSerialReader.m
//  guitarHero
//
//  Created by Jarrett Hawrylak on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ghSerialReader.h"

@implementation ghSerialReader

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithFile:(NSString *)file andHandler:(id<serialReaderDelegate>)h
{
    [self init];
    handler = h;
    fd = open([file cStringUsingEncoding:NSASCIIStringEncoding], O_RDONLY|O_NOCTTY|O_NONBLOCK);
    if(fd == -1)
    {
        NSLog(@"Error attempting to open file: %@ - %s",file,strerror(errno));
        return self;
    }
    speed_t baudRate = 57600;
    ioctl(fd, TIOCEXCL);
    fcntl(fd,F_SETFL,0);
    tcgetattr(fd, &origOptions);
    options = origOptions;
    cfmakeraw(&options);
    ioctl(fd,IOSSIOSPEED,&baudRate);
    [self performSelectorInBackground:@selector(serialRead:) withObject:[NSThread currentThread]];
    return self;
}

-(void)serialRead:(NSThread*)curThread
{
    char buffer[100];
    int index = 0;
    char nextc[1] = {'a'};
    int error = 1;
    while(error > 0)
    {
        error = read(fd,nextc,1);
        if(error <= 0) continue;
        //NSLog(@"Got %d",(int)nextc[0]);
        if(nextc[0] == '\n' || index == 99)
        {
            buffer[index] = 0;
            index = 0;
            [self processCommand:[NSString stringWithCString:buffer encoding:NSASCIIStringEncoding]];
            continue;
        }
        buffer[index++] = nextc[0];
    }
    NSLog(@"Errored out: %d - %s",error, strerror(errno));
}

-(void)processCommand:(NSString*)command
{
    NSScanner *cmd = [NSScanner scannerWithString:command];
    if([cmd scanString:@"STRUM" intoString:NULL] == YES)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:5];
        [cmd setCharactersToBeSkipped:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
         int i;
         while([cmd scanInt:&i])
         {
             NSNumber *n = [NSNumber numberWithInt:i];
             [arr addObject:n];
         }
        [handler strum:[NSArray arrayWithArray:arr]];
    } else if([cmd scanString:@"RELEASE" intoString:NULL] == YES)
    {
        [handler noteRelease];
    } else if([cmd scanString:@"DISTORTION" intoString:NULL] == YES)
    {
        [handler toggleDistortion];  
    } else {
        NSLog(@"Unknown command: %@", command);
    }
    return;
}


-(void)dealloc
{
    tcsetattr(fd,TCSANOW,&origOptions);
    close(fd);
    
    
    [super dealloc];
}
@end
