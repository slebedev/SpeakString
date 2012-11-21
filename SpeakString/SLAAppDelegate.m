//
//  SLAAppDelegate.m
//  SpeakString
//
//  Created by Sergey Lebedev on 21.11.12.
//  Copyright (c) 2012 Sergey Lebedev. All rights reserved.
//

#import "SLAAppDelegate.h"

#define debugging

@implementation SLAAppDelegate

@synthesize window,tableView,textField,startSpeakingButton,stopSpeakingButton;

#pragma mark -
#pragma mark Initiators

-(id)init {
    self = [super init];
    if (self) {
        speaker = [[NSSpeechSynthesizer alloc] init];
        voices = [NSSpeechSynthesizer availableVoices];
        [speaker setDelegate:self];
    }
    return self;
}

#pragma mark - IBActions

- (IBAction)stopSpeaking:(id)sender {
    if ([speaker isSpeaking])
        [speaker stopSpeaking];
}

- (IBAction)startSpeaking:(id)sender {
    NSString *stringToSpeak = [textField stringValue];
    if (![stringToSpeak isEqualToString:@""]) {
#ifdef debugging
        BOOL result = [speaker startSpeakingString:stringToSpeak];
        NSLog(@"%@",result?@"Speaking!":@"Error");
#else
        [speaker startSpeakingString:stringToSpeak];
#endif
    }
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

#pragma mark - NSTableViewDelegate

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger selRow = [tableView selectedRow];
    if (selRow>=0) {
        [speaker setVoice:[voices objectAtIndex:selRow]];
    } else [speaker setVoice:nil];
}

#pragma mark - NSTableViewDataSource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [voices count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *v = [voices objectAtIndex:row]; // String as "com.apple.speech.synthesis.voice.Alex"
    NSDictionary *voice = [NSSpeechSynthesizer attributesForVoice:v]; // Creates a dictionary from string v
    return [voice objectForKey:NSVoiceName]; // Returned attribute NSVoiceName
}

#pragma mark - NSSpeechSynthesizerDelegate

-(void)speechSynthesizer:(NSSpeechSynthesizer *)sender willSpeakPhoneme:(short)phonemeOpcode {
    [textField setEnabled:NO];
    [stopSpeakingButton setEnabled:YES];
}

-(void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking {
    [textField setEnabled:YES];
    [stopSpeakingButton setEnabled:NO];
#ifdef debugging
    NSLog(@"%@",finishedSpeaking?@"Finished!":@"Aborted!");
#endif
    if (finishedSpeaking) [textField setStringValue:@""]; //MARK: magic! If start speak after cell selected, finushedSpeaking is NO and textField not cleaned!
}

#pragma mark - NSWindowDelegate

-(void)windowWillClose:(NSNotification *)notification {
    [NSApp terminate:self]; // As we have single-window app, closing our window must terminate app
}

@end
