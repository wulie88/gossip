//
//  GSEMessageModel.m
//  Gossip
//
//  Created by jiuwu on 14-8-7.
//
//

#import "GSEMessageModel.h"

@implementation GSEMessageModel

+ (GSEMessageModel *)instance:(GSAccountConfiguration *)friend
{
    static GSEMessageModel *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    sharedInstance.friend = friend;
    return sharedInstance;
}

- (NSArray *)messages
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:self.friend.username];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}

- (void)appendMessage:(GSEMessage *)message
{
    NSMutableArray *messages = [[NSMutableArray alloc] initWithArray:self.messages];
    [messages addObject:message];
    
    NSArray *tmpArr = [[NSArray alloc] initWithArray:messages];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:messages] forKey:self.friend.username];
}

@end

@implementation GSEMessage

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:[NSNumber numberWithInt:self.type] forKey:@"type"];
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{   self = [super init];
    if (self) {
        self.type = [[aDecoder decodeObjectForKey:@"type"] intValue];
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
    }
    
    return self;
}


@end
