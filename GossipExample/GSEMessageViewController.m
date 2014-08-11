//
//  GSEMessageViewController.m
//  Gossip
//
//  Created by jiuwu on 14-8-6.
//
//

#import "GSEMessageViewController.h"
#import "GSEMessageModel.h"
#import "PJSIP.h"


@interface GSEMessageViewController () <UIAlertViewDelegate, GSAccountDelegate>

@property (nonatomic, copy) NSArray *messages;

@property (nonatomic, assign) GSEMessageModel *model;

@end

@interface MessageTableViewCell ()
{
    UILabel *_messageLabel;
}

@property (nonatomic, assign) GSEMessage *message;

@end




@implementation GSEMessageViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"To %@", self.friend.username];
    self.model = [GSEMessageModel instance:self.friend];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(replyButtonTouched:)];
    
    self.messages = self.model.messages;
    if (self.messages) {
        [self.tableView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0 ];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    GSAccount *account = [GSUserAgent sharedAgent].account;
    account.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    GSAccount *account = [GSUserAgent sharedAgent].account;
    account.delegate = nil;
}

- (void)replyButtonTouched:(id)sender
{
    [self showTextPrompt];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTextPrompt {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.tag = 1;
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView setTitle:@"Enter Message"];
    [[alertView textFieldAtIndex:0] setText:@"来自ios开发组的测试消息"];
    [alertView setDelegate:self];
    [alertView addButtonWithTitle:@"Cancel"];
    [alertView addButtonWithTitle:@"Send"];
    [alertView setCancelButtonIndex:0];
    [alertView show];
}

- (void)userDidEnterMessage:(NSString*)text
{
    GSAccount *account = [GSUserAgent sharedAgent].account;
	if ([account sendMessage:text toFriend:self.friend]) {

        GSEMessage *message = [[GSEMessage alloc] init];
        message.type = GSEMessageTypeMine;
        message.text = text;
        message.date = [NSDate date];
        
        [self.model appendMessage:message];
        self.messages = self.model.messages;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0 ];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - GSAccountDelegate
- (void)account:(GSAccount *)account didReceiveIM:(NSString *)text;
{
    GSEMessage *message = [[GSEMessage alloc] init];
    message.type = GSEMessageTypeFriend;
    message.text = text;
    message.date = [NSDate date];
    
    [self.model appendMessage:message];
    self.messages = self.model.messages;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0 ];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    UITextField *textField = [alertView textFieldAtIndex:0];
    return [[textField text] length] > 0;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex])
        return;
    
    [self userDidEnterMessage:[[alertView textFieldAtIndex:0] text]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.message = [self.messages objectAtIndex:indexPath.row];

    return cell;
}

@end

@implementation MessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)initView
{
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 34)];
    _messageLabel.numberOfLines = 2;
    [self addSubview:_messageLabel];
}


- (void)setMessage:(GSEMessage *)message
{
    _message = message;
    
    _messageLabel.textAlignment = message.type == 0 ? NSTextAlignmentRight : NSTextAlignmentLeft;
    _messageLabel.text = message.text;
}

@end
