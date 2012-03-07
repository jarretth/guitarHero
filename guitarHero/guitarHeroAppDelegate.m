//
//  guitarHeroAppDelegate.m
//  guitarHero
//
//  Created by Jarrett Hawrylak on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "guitarHeroAppDelegate.h"

@implementation guitarHeroAppDelegate
@synthesize redButton;
@synthesize yellowButton;
@synthesize blueButton;
@synthesize orangeButton;
@synthesize scaleSlider;
@synthesize volumeSlider;
@synthesize muteButton;
@synthesize greenButton;
@synthesize currentScale;

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    gso = [[guitarSoundObject alloc] init];
    ghs = [[ghSerialReader alloc] initWithFile:@"/dev/cu.usbmodemfd121" andHandler:self];
    mute = 1;
    volume = 1.0;
    scales[0] = 0; //A5 - 220Hz - 0
    scales[1] = 1; //B5 - 2
    scales[2] = 3; //C5 - 3
    scales[3] = 5; //D5 - 5
    scales[4] = 7; //E5 - 7
    scales[5] = 8; //F5 - 8
    scales[6] = 10; //G5 - 10
    for(int i = 0; i < 5; i++)
        notesOn[i] = 0;
    currentScale = 0;
    gso.scale = [guitarHeroAppDelegate noteToScale:currentScale];
    gso.enabledNotes = [self enabledNotes];
    [self updateView];
    /*scales[0][0] = 'A';
    scales[0][1] = 'C'; //+3
    scales[0][2] = 'D'; //+2
    scales[0][3] = 'E'; //+2
    scales[0][4] = 'G'; //+3
    */
}

- (IBAction)buttonPressed:(id)sender {
    NSButton *input = (NSButton*)sender;
    notesOn[input.tag] = (int)input.state;
    gso.enabledNotes = [self enabledNotes];
    //[gso refreshSound];
    [self updateView];
}

- (IBAction)openWindow:(id)sender {
    if(!window.isVisible) [window makeKeyAndOrderFront:self];
}

- (IBAction)scaleChanged:(id)sender {
    NSSlider *slider = (NSSlider*)sender;
    currentScale = [slider intValue];
    gso.scale = [guitarHeroAppDelegate noteToScale:currentScale];
    [gso refreshSound];
//    NSLog(@"currentScale set to %d, slider intValue: %f", currentScale, [slider intValue]);
    [self updateView];
}

- (IBAction)changeVolume:(id)sender {
    [gso setVolume:volume = [sender floatValue]];
    [self updateView];
}

- (IBAction)mutePressed:(id)sender {
    mute = (int)((NSButton*)sender).state;
    if(mute)
        [gso stopSound];
    else
        [gso startSound];
    [self updateView];
}

-(void)updateView
{
    greenButton.state = notesOn[0];
    redButton.state = notesOn[1];
    yellowButton.state = notesOn[2];
    blueButton.state = notesOn[3];
    orangeButton.state = notesOn[4];
    scaleSlider.intValue = currentScale;
    volumeSlider.floatValue = mute ? 0.0 : volume;
    volumeSlider.enabled = mute ? false : true;
    muteButton.state = mute;
}

-(NSArray *)enabledNotes
{
    NSNumber * bools[5];
    for(int i = 0; i < 5; i++)
    {
        bools[i] = [NSNumber numberWithBool:notesOn[i]];
    }
    return [NSArray arrayWithObjects:(id*)&bools count:5];
}

+(NSArray *)noteToScale:(int)note
{
    NSNumber *scale[5];
    int curNote = note;
    for(int i = 0; i < 5; i++)
    {
        int octave = 4;
        float freq = (275 * pow(2.0, octave) * pow(1.059463,curNote))/10;
        scale[i] = [NSNumber numberWithFloat:freq];
        switch(i) //pentatonic minor
        {
            case 0:
            case 3: curNote += 3;
                break;
            case 1:
            case 2: curNote += 2;
                break;
            default: break;
        }
    }
    NSArray *ret = [NSArray arrayWithObjects:(id*)&scale count:5];
    //NSLog(@"Got scale [%@] from note %d",ret,note);
    return ret;
}

-(void)strum:(NSArray *)notes
{
    NSLog(@"Strum",notes);
    for(int i = 0; i < [notes count]; i++)
    {
        NSNumber *n = [notes objectAtIndex:i];
        notesOn[i] = [n intValue] ? true : false;
    }
    gso.enabledNotes = [self enabledNotes];
    [self updateView];
    [gso refreshSound];
}

-(void)hammerOn:(NSArray *)notes
{
    NSLog(@"Hammer");
    for(int i = 0; i < [notes count]; i++)
    {
        NSNumber *n = [notes objectAtIndex:i];
        notesOn[i] = [n intValue] ? true : false;
    }
    gso.enabledNotes = [self enabledNotes];
    [gso hammer];
    [gso refreshSound];
    [self updateView];
}

-(void)noteRelease
{
    NSLog(@"Release");
    for(int i = 0; i < 5; i++)
    {
        notesOn[i] = false;
    }
    gso.enabledNotes = [self enabledNotes];
    [self updateView];
//    [gso refreshSound];
}

-(void)toggleDistortion
{
    NSLog(@"Distortion");
    gso.distortion = !gso.distortion;
    //[gso refreshSound];
}
@end
