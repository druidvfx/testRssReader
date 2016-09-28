//
//  ImageLinkParse.h
//  testRssReader
//
//  Created by Alexey Volkov on 28.09.16.
//  Copyright © 2016 Alexey Volkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageLinkParseDelegate

@required
-(void)imageLinkParseComplite:(NSString*)imageLink;	// сообщает о завершении парсинга линка имаджа
@optional

@end



@interface ImageLinkParse : NSObject
{
	NSMutableData *responseData;
}
@property (nonatomic, assign) id<ImageLinkParseDelegate>	delegate;

-(id)init;
-(void)getImageLink:(NSString*)imageLink;
@end
