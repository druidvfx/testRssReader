//
//  ImageLinkParse.m
//  testRssReader
//
//  Created by Alexey Volkov on 28.09.16.
//  Copyright © 2016 Alexey Volkov. All rights reserved.
//

#import "ImageLinkParse.h"

@implementation ImageLinkParse

@synthesize delegate;

// делегат
-(void)imageLinkParseComplite:(NSString*)imageLink
{
	
}



-(id)init
{
	self = [super init];
	if (self != nil)
	{
		delegate = (id<ImageLinkParseDelegate>)self;
	}
	return self;
}



-(void)getImageLink:(NSString*)_imageLink
{
	NSURL *url = [[NSURL alloc] initWithString:_imageLink];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setHTTPMethod:@"GET"];
	
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[conn start];
	
	if(conn)
	{
		// Data Received
		responseData = [[NSMutableData alloc] init];
		return;
	}
	
	// error
	[delegate imageLinkParseComplite:nil];
	
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self->responseData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *string = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	[self findImageURL:string];
}


//парсинг на основе регулярных выражений
-(void) findImageURL: (NSString*) text
{
	//создаем регулярное выражение для поиска картинки
	NSString *regExpFull=@"<meta property=\"og:image\" content=\".*\"";
	
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExpFull
																		   options:NSRegularExpressionCaseInsensitive
																			 error:NULL];
	//производим поиск
	NSArray *matchs = [regex matchesInString:text options:0 range:NSMakeRange(0,text.length)];
	NSString *substringLink;
	
	if (matchs.count > 0)
	{
		// если нашли кладем в substring
		NSString *substring;
		NSTextCheckingResult* result =  [matchs objectAtIndex:0];
		substring=[text substringWithRange:[result rangeAtIndex:0]];
		
		
		
		
		NSString *regExpPart=@"\http.*\.*\"";
		regex = [NSRegularExpression regularExpressionWithPattern:regExpPart
														  options:NSRegularExpressionCaseInsensitive
															error:NULL];
		
		NSArray *matchs2 = [regex matchesInString:substring options:0 range:NSMakeRange(0, substring.length)];
		
		if (matchs2.count > 0)
		{
			NSTextCheckingResult* result2 =  [matchs2 objectAtIndex:0];
			substringLink = [substring substringWithRange:[result2 rangeAtIndex:0]];
			
			substringLink = [substringLink substringToIndex:[substringLink length] - 1];
			NSLog(@"%@",substringLink);
			
			[delegate imageLinkParseComplite:substringLink];
		}
		
	}
	[delegate imageLinkParseComplite:nil];
	
	
}


@end
