//
//  GSEConfigurationViewController.h
//  Gossip
//
//  Created by Chakrit Wichian on 7/6/12.
//

#import "Gossip.h"

@interface GSEConfigurationViewController : UIViewController

+ (NSArray*)accounts;
+ (GSAccountConfiguration *)currentAccount;
+ (void)setCurrentAccount:(GSAccountConfiguration*)currentAccount;

@end
