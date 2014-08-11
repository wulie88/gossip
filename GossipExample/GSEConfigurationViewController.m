//
//  GSEConfigurationViewController.m
//  Gossip
//
//  Created by Chakrit Wichian on 7/6/12.
//

#import "GSEConfigurationViewController.h"
#import "GSECodecsViewController.h"
#import "GSEMenuViewController.h"


@interface GSEConfigurationViewController () <UITableViewDataSource, UITableViewDelegate> @end


@implementation GSEConfigurationViewController {
    UITableView *_tableView;
    NSArray *_testAccounts;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _testAccounts = [GSEConfigurationViewController accounts];
    }
    return self;
}


static GSAccountConfiguration *theCurrentAccount;
+ (GSAccountConfiguration *)currentAccount
{
    return theCurrentAccount;
}


+ (void)setCurrentAccount:(GSAccountConfiguration*)currentAccount;
{
    theCurrentAccount = currentAccount;
}

+ (NSArray*)accounts
{
    static NSMutableArray *accounts;
    if (accounts) {
        return accounts;
    }
    
    accounts = [NSMutableArray array];
    
    GSAccountConfiguration *account = [GSAccountConfiguration defaultConfiguration];
    account.address = @"18627162511@192.168.1.16";
    account.username = @"18627162511";
    account.password = @"123456";
    account.domain = @"112.126.65.201";
    [accounts addObject:account];
    
    account = [account copy];
    account.address = @"18827676190@192.168.1.16";
    account.username = @"18827676190";
    account.password = @"123456789";
    [accounts addObject:account];
    
    account = [account copy];
    account.address = @"13995599202@192.168.1.16";
    account.username = @"13995599202";
    account.password = @"123456789";
    [accounts addObject:account];
    
    return accounts;
}

- (void)dealloc {
    _testAccounts = nil;
}


- (NSString *)title {
    return @"Account";
}


- (void)loadView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    _tableView = [UITableView alloc];
    _tableView = [_tableView initWithFrame:frame style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    UIView *container = [[UIView alloc] init];
    [container setFrame:frame];
    [container addSubview:_tableView];
    [self setView:container];
}

- (void)viewDidAppear:(BOOL)animated {
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}


- (void)userDidSelectAccount:(GSAccountConfiguration *)accountConfig {
    GSConfiguration *configuration = [GSConfiguration defaultConfiguration];
    configuration.account = accountConfig;
    configuration.logLevel = 3;
    configuration.consoleLogLevel = 3;
    
    GSUserAgent *agent = [GSUserAgent sharedAgent];
    [agent configure:configuration];
    [agent start];
    
    GSEMenuViewController *menu = [[GSEMenuViewController alloc] init];
    menu.account = agent.account; // only one account supported, for now.
    [[self navigationController] pushViewController:menu animated:YES];
}


#pragma mark - UITableViewDatasource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [_testAccounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const kCellId = @"sip_account";
    
    NSInteger row = [indexPath row];
    if (row < 0 || row == [_testAccounts count])
        return nil;
    
    // build table cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (!cell) {
        cell = [UITableViewCell alloc];
        cell = [cell initWithStyle:UITableViewCellStyleDefault
                   reuseIdentifier:kCellId];
    }
    
    GSAccountConfiguration *account = [_testAccounts objectAtIndex:row];
    [[cell textLabel] setText:account.username];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if (row < 0 || row == [_testAccounts count])
        return;
    
    GSAccountConfiguration *account = [_testAccounts objectAtIndex:row];
    [GSEConfigurationViewController setCurrentAccount:account];
    [self userDidSelectAccount:account];
}

@end
