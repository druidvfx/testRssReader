//
//  RssParse.h
//  testRssReader
//
//  Created by Alexey Volkov on 28.09.16.
//  Copyright © 2016 Alexey Volkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RssParseDelegate

@required
-(void)rssXMLParseComplite:(NSMutableArray*)feeds;	// сообщает о завершении парсинга rssXML
@optional

@end



@interface RssParse : NSObject <NSXMLParserDelegate>
{
	NSXMLParser *parserRss;
	
	NSMutableArray *feeds;		// массив новостями
	
	NSMutableDictionary *item;	// словарь одной новости
	NSMutableString *title;		// титле новости
	NSMutableString *link;		// линк новости
	NSMutableString *imageLink;	// линк на имадж
	
	NSString *element;
	
	NSMutableData *responseData;	// 

}
@property (nonatomic, assign) id<RssParseDelegate>	delegate;

-(id)init;
-(void)parseRssLink:(NSString*)rssLink;

@end
