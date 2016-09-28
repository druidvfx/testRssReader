//
//  RssParse.m
//  testRssReader
//
//  Created by Alexey Volkov on 28.09.16.
//  Copyright © 2016 Alexey Volkov. All rights reserved.
//

#import "RssParse.h"

@implementation RssParse

@synthesize delegate;

// делегат
-(void)rssXMLParseComplite:(NSMutableArray*)feeds
{
	
}


-(id)init
{
	self = [super init];
	if (self != nil)
	{
		delegate = (id<RssParseDelegate>)self;
	}
	return self;
}



-(void)parseRssLink:(NSString*)rssLink
{
		NSURL *rssUrl = [NSURL URLWithString:rssLink];

		feeds = [[NSMutableArray alloc] init];
		
		parserRss = [[NSXMLParser alloc] initWithContentsOfURL:rssUrl];
		[parserRss setDelegate:self];
		[parserRss setShouldResolveExternalEntities:NO];
		
		if ([parserRss parse] == NO)
		{
			[delegate rssXMLParseComplite:nil];
		}
}





// парсер нашел начало элемента
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	element = elementName;
	
	if ([element isEqualToString:@"item"])
	{
		// если это item - то создаем словарь под него
		item    = [[NSMutableDictionary alloc] init];
		title   = [[NSMutableString alloc] init];
		link    = [[NSMutableString alloc] init];
	}
}


// парсер нашел конец элемента
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"item"])
	{
		// если это был итем то добавляем ему имя title и link
		[item setObject:title forKey:@"title"];
		[item setObject:link forKey:@"link"];
		
		// и кладем в массив новостей
		NSMutableDictionary *newItem = [[NSMutableDictionary alloc] initWithDictionary:item];
		[feeds addObject:newItem];
	}
}


// парсер достал стринг данные элемента
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	// когда мы нашли данные
	if ([element isEqualToString:@"title"])
	{
		[title appendString:string];
	}
	else if ([element isEqualToString:@"link"])
	{
		[link appendString:string];
	}
	
}

// все отпарсили
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	[delegate rssXMLParseComplite:feeds];
}





@end
