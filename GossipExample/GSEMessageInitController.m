//
//  GSEMessageInitController.m
//  Gossip
//
//  Created by jiuwu on 14-8-6.
//
//

#import "GSEMessageInitController.h"
#import "GSEConfigurationViewController.h"
#import "GSEMessageViewController.h"
#import "Gossip.h"
#import <UIKit/UIKit.h>

@interface GSEMessageInitController () <UIActionSheetDelegate>
{
    NSArray *_accounts;
}

@end

@implementation GSEMessageInitController

@synthesize navigationController = _navigationController;

- (void)makeNewMessage {
    _accounts = [GSEConfigurationViewController accounts];
    
    [self showFriendChoices];
}

- (void)showFriendChoices {
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    [sheet setTitle:@"Select A Friend"];
    [sheet setDelegate:self];
    for (GSAccountConfiguration *account in _accounts) {
        if (![account isEqual:[GSEConfigurationViewController currentAccount]]) {
            [sheet addButtonWithTitle:account.username];
        }
    }
    
    [sheet addButtonWithTitle:@"Cancel"];
    [sheet setCancelButtonIndex:sheet.numberOfButtons - 1];
    [sheet showInView:[_navigationController view]];
}

- (void)userDidFriend:(GSAccountConfiguration *)friend {
    
    GSEMessageViewController *controller = [[GSEMessageViewController alloc] init];
    controller.friend = friend;
    
    [_navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex])
        return;
    
    NSString *username = [actionSheet buttonTitleAtIndex:buttonIndex];
    for (GSAccountConfiguration *account in _accounts) {
        if ([account.username isEqualToString:username]) {
            [self userDidFriend:account];
        }
    }
}


@end
