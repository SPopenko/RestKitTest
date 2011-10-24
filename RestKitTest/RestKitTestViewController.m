//
//  RestKitTestViewController.m
//  RestKitTest
//
//  Created by vb on 10/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RestKitTestViewController.h"
#import <RestKit/RestKit.h>
#import <RestKit/Support/JSON/JSONKit/RKJSONParserJSONKit.h>

@interface UIProgressHUD : NSObject 
- (UIProgressHUD *) initWithWindow: (UIView*)aWindow; 
- (void) show: (BOOL)aShow; 
- (void) setText: (NSString*)aText; 
@end

@interface Image :NSObject
@property (nonatomic, retain) NSString* url;
@end

@implementation Image
@synthesize url = _url;
@end

@interface Poster : NSObject {
}

@property (nonatomic, retain) Image* image;
@end

@implementation Poster
@synthesize image = _image;
@end

@interface ShortMovieInfo : NSObject {
}

@property (nonatomic, retain) NSNumber* movieID;
@property (nonatomic, retain) NSArray* posters;

@end

@implementation ShortMovieInfo

@synthesize movieID = _movieID;
@synthesize posters = _posters;

@end

@implementation RestKitTestViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [RKObjectManager objectManagerWithBaseURL:@"http://api.themoviedb.org/2.1"]; 
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/json"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    HUD = [[UIProgressHUD alloc] initWithWindow:self.view]; 
    [HUD setText:@"Doing something slow. Please wait."]; 
    [HUD show:YES]; 
    
    RKObjectMapping* imageMapping = [RKObjectMapping mappingForClass:[Image class] ];
    [imageMapping mapAttributes:@"url", nil];
    
    RKObjectMapping* posterMaping = [RKObjectMapping mappingForClass:[Poster class] ];
    [posterMaping mapRelationship:@"image" withMapping: imageMapping];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[ShortMovieInfo class]];
    [mapping mapKeyPathsToAttributes: @"id", @"movieID",nil];
    [mapping mapKeyPath:@"posters" toRelationship:@"posters" withMapping:posterMaping];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/Movie.browse/en-US/json/ed2f89aa774281fcada8f17b73c8fa05?order_by=rating&order=desc&genres=18&min_votes=5&page=1&per_page=1" objectMapping:mapping delegate:self];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    ShortMovieInfo* account = [[objects objectAtIndex:0] retain];
    [account retain];
    [HUD show:NO]; 
    [HUD release];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString *temp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
    NSLog(@"%@",temp);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
