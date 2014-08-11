//
//  GSEMessageModel.h
//  Gossip
//
//  Created by jiuwu on 14-8-7.
//
//

#import <Foundation/Foundation.h>
#import "Gossip.h"

typedef NS_ENUM(NSUInteger, GSEMessageType)
{
    GSEMessageTypeMine = 0,
    GSEMessageTypeFriend,
};

@interface GSEMessage : NSObject <NSCoding>

@property (nonatomic, assign) GSEMessageType type; // 0 mine 1 friend

@property (nonatomic, retain) NSDate *date;

@property (nonatomic, copy) NSString *text;

@end

@interface GSEMessageModel : NSObject

// 获得和好友的对话
+ (GSEMessageModel*)instance:(GSAccountConfiguration*)friend;

- (void)appendMessage:(GSEMessage*)message;

@property (nonatomic, retain, readonly) NSArray *messages;

@property (nonatomic, assign) GSAccountConfiguration *friend;

@end
