//
//  GSEMessageViewController.h
//  Gossip
//
//  Created by jiuwu on 14-8-6.
//
//

#import <UIKit/UIKit.h>
#import "Gossip.h"

@interface MessageTableViewCell : UITableViewCell

@end

@interface GSEMessageViewController : UITableViewController

@property (nonatomic, assign) GSAccountConfiguration *friend;


@end
