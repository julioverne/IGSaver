#import <objc/runtime.h>
#import <substrate.h>
#import <Foundation/Foundation.h>

#import "IGSaverImportListController.h"

#import "../mejordownload/MejorDownload/MejorDownloadWindow.h"
#include "../mejordownload/MejorDownload/MejorDownloadWindow.m"
#import "../mejordownload/MejorDownload/DRCircularProgressView.h"
#include "../mejordownload/MejorDownload/DRCircularProgressView.m"
#import "../mejordownload/MejorDownload/MejorDownloadConnection.h"
#include "../mejordownload/MejorDownload/MejorDownloadConnection.m"

#define BUTTON_DOWN_SIZE 451
#define BUTTON_DOWN_BYTES "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x40\x00\x00\x00\x40\x08\x06\x00\x00\x00\xAA\x69\x71\xDE\x00\x00\x00\x06\x62\x4B\x47\x44\x00\xFF\x00\xFF\x00\xFF\xA0\xBD\xA7\x93\x00\x00\x01\x78\x49\x44\x41\x54\x78\x9C\xED\x99\x31\x4E\xC3\x30\x18\x46\x9F\x2B\x4E\x02\x2B\x37\xE8\xCA\x1D\x18\x10\xAC\x3D\x02\x6B\x2B\x56\xC4\x04\x02\xA9\xAC\x45\xE2\x3E\x8C\xF4\x04\x4C\x08\x66\xC2\x10\x47\x4D\xA3\x24\x90\xA8\xE9\x97\x26\xDF\x93\x2C\x59\x8D\xD3\x3C\x7F\xF9\xE3\x56\x31\x18\x63\x8C\x31\xC6\x98\x71\x12\x84\xD7\x9E\x00\x17\xB1\xBF\x02\x7E\x84\x2E\x12\xAE\x80\x24\xB6\x4B\x95\xC4\x44\x75\x61\xE0\x38\xD7\x3F\x51\x49\x28\x03\xE8\x05\x0E\x40\x2D\xA0\xC6\x01\xA8\x05\xD4\x38\x00\xB5\x80\x1A\x07\xA0\x16\x50\xE3\x00\xD4\x02\x6A\x1C\x80\x5A\x40\x8D\x03\x50\x0B\xA8\xE9\x3A\x80\x1B\xE0\x1B\xB8\xA5\xD9\xDB\xA7\x00\xDC\xC5\x73\x17\x1D\x78\xED\x8D\x2F\x36\x6F\x7D\x9E\xD8\x0E\x61\x9E\x3B\x36\xCF\x7D\x1E\xE2\xD8\xEC\xD8\x67\x97\x82\x5D\x57\xC0\x32\xD7\x9F\x01\x8F\xD4\x57\x42\x88\x63\x66\x15\xDF\x71\x70\x04\xE0\x9E\xCD\xDD\x4C\x80\x67\xD2\xE0\x8B\x15\x10\x80\x87\xC2\xD8\x25\x03\x58\xA7\xAA\x42\x58\xB0\x1D\xC0\x20\x27\x9F\x51\x7C\xAE\x13\xE0\xA3\xA2\x5F\xB6\x5E\x0C\x82\xB2\x4A\x28\x6B\x83\xBA\xF3\x45\xFE\x0A\x61\xD0\x93\xCF\xA8\x0A\x61\x14\x93\xCF\x28\x86\x20\x9B\xBC\x72\xA1\x09\xC0\x79\xEC\xBF\x92\x06\x61\xF6\x4D\x93\x0A\xE8\xFB\x6E\x6E\xE7\x7E\xBD\xD8\xCD\xAD\xA1\x95\x5F\x93\x85\xA7\x17\xBB\xB9\x35\xB4\xF2\x1B\xCD\xCF\x4E\x15\x0E\x40\x2D\xA0\xC6\x01\xA8\x05\xD4\x38\x00\xB5\x80\x9A\xA3\x96\xE7\x4D\x81\xEB\x5D\x8A\xEC\x80\x69\x9B\x93\xDA\x06\x70\x16\xDB\xC1\xD3\xE4\x11\x58\x77\x66\xB1\x7B\xDE\xFF\x3B\xB0\x49\x05\xAC\x48\xFF\x67\x9F\x36\xD6\xD9\x2F\x6F\xC0\x8B\x5A\xC2\x18\x63\x8C\x31\xC6\xF4\x9D\x5F\xF0\x43\x63\x72\xDB\x0B\x31\x80\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82"

static UIButton* downloadButton()
{
	UIButton* btDown = [UIButton buttonWithType:UIButtonTypeCustom];
	btDown.tintColor = [UIColor whiteColor];
	
	NSData *dataImg = [NSData dataWithBytes:BUTTON_DOWN_BYTES length:BUTTON_DOWN_SIZE];
	UIImage* btnImage = [[UIImage imageWithData:dataImg] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[btDown setImage:btnImage forState:UIControlStateNormal];
	return btDown;
}

@interface IGSaverSettingsViewController : PSListController
{
	UILabel* _label;
	UILabel* underLabel;
}
- (void)HeaderCell;
@end

@interface NSUserDefaults ()
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)removeObjectForKey:(id)arg1 inDomain:(id)arg2;
//- (NSDictionary*)volatileDomainForName:(id)arg1;
@end


@interface IGSaverAlbumManagerViewController : UITableViewController
@property (strong) NSMutableDictionary *albumDic;
@end

@implementation IGSaverAlbumManagerViewController
@synthesize albumDic;
- (void)loadView
{
	[super loadView];
	
	self.title = @"Album Preset's";
	
	[self refresh:nil];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIRefreshControl *refreshControl;
	if(!refreshControl) {
		refreshControl = [[UIRefreshControl alloc] init];
		[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
		refreshControl.tag = 8654;
	}
	UITableView* tableV = (UITableView *)self.tableView;
	if(tableV) {
		UIView* rem = [tableV viewWithTag:8654];
		if(rem) {
			[rem removeFromSuperview];
		}
		[tableV addSubview:refreshControl];
	}
}
- (void)refresh:(UIRefreshControl *)refresh
{
	albumDic = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.julioverne.igsaver.user"]?:@{} mutableCopy];
	
	if(self.tableView) {
		[self.tableView reloadData];
	}
	if(refresh) {
		[refresh endRefreshing];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	__strong UIBarButtonItem* kBTClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeEdit)];
	@try {
		kBTClose.tintColor = [UIColor labelColor];
	}@catch(NSException*e){
	}
	kBTClose.tag = 4;	
	if (self.navigationController.navigationBar.backItem == NULL) {
		self.navigationItem.leftBarButtonItem = kBTClose;
	}
}

- (void)closeEdit
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[albumDic allKeys] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
	cell.textLabel.text =  [albumDic allKeys][indexPath.row];
	//cell.accessoryType = isdir ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	cell.detailTextLabel.text = albumDic[[albumDic allKeys][indexPath.row]];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[albumDic allKeys][indexPath.row] inDomain:@"com.julioverne.igsaver.user"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self refresh:nil];
}

- (void)showAlerForIndexPath:(NSIndexPath *)indexPath
{
	NSString* accountName = [albumDic allKeys][indexPath.row];
	NSString* albumName = albumDic[[albumDic allKeys][indexPath.row]];
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"IGSaver" message:[NSString stringWithFormat:@"Choose Option For Account \"%@\":", accountName] preferredStyle:UIAlertControllerStyleAlert];
	
	[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = albumName;
	}];
	
	UIAlertAction* Action2 = [UIAlertAction actionWithTitle:@"Rename Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
		UITextField *newName = alert.textFields.firstObject;
		if(newName && ![newName.text isEqualToString:@""]) {
			[[NSUserDefaults standardUserDefaults] setObject:newName.text forKey:accountName inDomain:@"com.julioverne.igsaver.user"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[self refresh:nil];
		}
	}];
	[alert addAction:Action2];
	
	UIAlertAction* Action3 = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *alertAction) {
		[self tableView:self.tableView commitEditingStyle:(UITableViewCellEditingStyle)1 forRowAtIndexPath:indexPath];
	}];
	[alert addAction:Action3];
	
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
		[self refresh:nil];
	}];
	[alert addAction:cancel];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self showAlerForIndexPath:indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

@implementation IGSaverSettingsViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	__strong UIBarButtonItem* kBTClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeEdit)];
	@try {
		kBTClose.tintColor = [UIColor labelColor];
	}@catch(NSException*e){
	}
	kBTClose.tag = 4;	
	if (self.navigationController.navigationBar.backItem == NULL) {
		self.navigationItem.leftBarButtonItem = kBTClose;
	}
}
- (void)closeEdit
{
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (id)specifiers
{
	if (!_specifiers) {
		NSMutableArray* specifiers = [NSMutableArray array];
		PSSpecifier* spec;
		
		
		//spec = [PSSpecifier preferenceSpecifierNamed:@"Download Mode"
		//                                      target:self
		//									  set:Nil
		//									  get:Nil
        //                                      detail:Nil
		//									  cell:PSGroupCell
		//									  edit:Nil];
		//[spec setProperty:@"Download Mode" forKey:@"label"];
		//[specifiers addObject:spec];
		//spec = [PSSpecifier preferenceSpecifierNamed:@"Download Mode"
		//									  target:self
		//										 set:@selector(setPreferenceValue:specifier:)
		//										 get:@selector(readPreferenceValue:)
		//									  detail:Nil
		//										cell:PSSegmentCell
		//										edit:Nil];		
		//[spec setValues:@[@(1), @(2), ] titles:@[ @"Alert", @"Silent", ]];
		//[spec setProperty:@"downloadMode" forKey:@"key"];
		//[spec setProperty:@(1) forKey:@"default"];
		//[specifiers addObject:spec];
		
		spec = [PSSpecifier emptyGroupSpecifier];
        //[specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Comfirm Download Prompt"
						  target:self
												 set:@selector(setPreferenceValue:specifier:)
												 get:@selector(readPreferenceValue:)
						  detail:Nil
												cell:PSSwitchCell
												edit:Nil];
		[spec setProperty:@"comfirmDownload" forKey:@"key"];
		[spec setProperty:@NO forKey:@"default"];
		[specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Album Preset"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Album Preset" forKey:@"label"];
		[spec setProperty:@"Manage Stored Album Preset By Account." forKey:@"footerText"];
		[specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Manage Album Preset"
					      target:self
						 set:NULL
						 get:NULL
					      detail:Nil
						cell:PSLinkCell
						edit:Nil];
		spec->action = @selector(openManager);
		[specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Batch Mode"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Batch Mode" forKey:@"label"];
		[spec setProperty:@"Download All Media From An Post/Stories." forKey:@"footerText"];
		[specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Post"
						  target:self
												 set:@selector(setPreferenceValue:specifier:)
												 get:@selector(readPreferenceValue:)
						  detail:Nil
												cell:PSSwitchCell
												edit:Nil];
		[spec setProperty:@"batchMode" forKey:@"key"];
		[spec setProperty:@NO forKey:@"default"];
		[specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Stories"
						  target:self
												 set:@selector(setPreferenceValue:specifier:)
												 get:@selector(readPreferenceValue:)
						  detail:Nil
												cell:PSSwitchCell
												edit:Nil];
		[spec setProperty:@"batchModeHistory" forKey:@"key"];
		[spec setProperty:@NO forKey:@"default"];
		[specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Auto-Save"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Auto-Save" forKey:@"label"];
		[specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Auto-Save Aways"
						  target:self
												 set:@selector(setPreferenceValue:specifier:)
												 get:@selector(readPreferenceValue:)
						  detail:Nil
												cell:PSSwitchCell
												edit:Nil];
		[spec setProperty:@"autoSave" forKey:@"key"];
		[spec setProperty:@NO forKey:@"default"];
		[specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"In Preset Album For Account"
						  target:self
												 set:@selector(setPreferenceValue:specifier:)
												 get:@selector(readPreferenceValue:)
						  detail:Nil
												cell:PSSwitchCell
												edit:Nil];
		[spec setProperty:@"autoSaveAcc" forKey:@"key"];
		[spec setProperty:@NO forKey:@"default"];
		[specifiers addObject:spec];
		
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Choose Quality"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Choose Quality" forKey:@"label"];
		[specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Quality"
											  target:self
												 set:@selector(setPreferenceValue:specifier:)
												 get:@selector(readPreferenceValue:)
											  detail:Nil
												cell:PSSegmentCell
												edit:Nil];		
		[spec setValues:@[@(1), @(2), ] titles:@[ @"Prompt", @"Best Available", ]];
		[spec setProperty:@"downloadQuality" forKey:@"key"];
		[spec setProperty:@(2) forKey:@"default"];
		[specifiers addObject:spec];
		
		
		spec = [PSSpecifier emptyGroupSpecifier];
        [specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Reset Settings"
					      target:self
						 set:NULL
						 get:NULL
					      detail:Nil
						cell:PSLinkCell
						edit:Nil];
		spec->action = @selector(reset);
		[specifiers addObject:spec];
		
		
		spec = [PSSpecifier emptyGroupSpecifier];
        [spec setProperty:@"IGSaver © 2021" forKey:@"footerText"];
        [specifiers addObject:spec];
		_specifiers = [specifiers copy];
	}
	return _specifiers;
}

- (void)reset
{
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"com.julioverne.igsaver.user"];
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"com.julioverne.igsaver"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self refresh:nil];
}

- (void)setRightButton
{
	//__strong UIBarButtonItem* kBTRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(openManager)];
	//kBTRight.tag = 4;
	//self.navigationItem.rightBarButtonItems = @[kBTRight];	
}

- (void)openManager
{
	UIViewController* settingsVC = [[objc_getClass("IGSaverAlbumManagerViewController") alloc] init];
	UINavigationController* navCC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
	[self presentViewController:navCC animated:YES completion:nil];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"IGSaver Settings";
	[self setRightButton];
	UIRefreshControl *refreshControl;
	if(!refreshControl) {
		refreshControl = [[UIRefreshControl alloc] init];
		[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
		refreshControl.tag = 8654;
	}
	UITableView* tableV = (UITableView *)object_getIvar(self, class_getInstanceVariable([self class], "_table"));
	if(tableV) {
		UIView* rem = [tableV viewWithTag:8654];
		if(rem) {
			[rem removeFromSuperview];
		}
		[tableV addSubview:refreshControl];
	}
}
- (void)refresh:(UIRefreshControl *)refresh
{	
	[self reloadSpecifiers];
	if(refresh) {
		[refresh endRefreshing];
	}
}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier
{
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:[specifier identifier] inDomain:@"com.julioverne.igsaver"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self refresh:nil];
}

- (id)readPreferenceValue:(PSSpecifier*)specifier
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:[specifier identifier] inDomain:@"com.julioverne.igsaver"]?:[[specifier properties] objectForKey:@"default"];
}

- (void)_returnKeyPressed:(id)arg1
{
	//[super _returnKeyPressed:arg1];
	[self.view endEditing:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void) loadView
{
	[super loadView];
	
	[self HeaderCell];
}
- (void)increaseAlpha
{
	[UIView animateWithDuration:0.5 animations:^{
		_label.alpha = 1;
	}completion:^(BOOL finished) {
		[UIView animateWithDuration:0.5 animations:^{
			underLabel.alpha = 1;
		}completion:nil];
	}];
}
- (void)HeaderCell
{
	@autoreleasepool {
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 120)];
		int width = [[UIScreen mainScreen] bounds].size.width;
		CGRect frame = CGRectMake(0, 20, width, 60);
		CGRect botFrame = CGRectMake(0, 55, width, 60);
		_label = [[UILabel alloc] initWithFrame:frame];
		[_label setNumberOfLines:1];
		_label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:48];
		[_label setText:@"IGSaver"];
		[_label setBackgroundColor:[UIColor clearColor]];
		//_label.textColor = [UIColor blackColor];
		_label.textAlignment = NSTextAlignmentCenter;
		_label.alpha = 0;
		underLabel = [[UILabel alloc] initWithFrame:botFrame];
		[underLabel setNumberOfLines:1];
		underLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[underLabel setText:@"Instagram Media Saver"];
		[underLabel setBackgroundColor:[UIColor clearColor]];
		underLabel.textColor = [UIColor grayColor];
		underLabel.textAlignment = NSTextAlignmentCenter;
		underLabel.alpha = 0;
		[headerView addSubview:_label];
		[headerView addSubview:underLabel];
		[_table setTableHeaderView:headerView];
		[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(increaseAlpha) userInfo:nil repeats:NO];
	}
}
@end


@interface IGUser : NSObject
@property (strong) NSString* username;
@end

@interface IGImageURL : NSObject
@property (strong) NSURL * url;
@property (assign) CGFloat width;
@property (assign) CGFloat height;
@end

@interface IGPhoto : NSObject
{
	NSArray* _originalImageVersions;
}
@end

@interface IGVideo : NSObject
@property (strong) NSArray * videoVersionDictionaries;
@property (strong) NSArray * videoVersions; // old ver
@end

@interface IGPostItem : NSObject
@property (assign) int mediaType;
@property (strong) IGPhoto * photo;
@property (strong) IGVideo * video;

@property (strong) IGUser * user;
@end

@interface IGCommentModel : NSObject
@property (strong) NSString * text;
@end 

@interface IGFeedItem : NSObject
@property (strong) NSArray * items;
@property (strong) IGCommentModel * caption;

@property (strong) IGPostItem * media;
@property (strong) IGPostItem * feedItem;

@end 

@interface IGFeedItemPageCellState : NSObject
@property (assign) int currentItemIndex;
@end

@interface IGFeedItemUFICell : UITableViewCell
@property (strong) UIButton * moreOptionsButtonIGSaver;

@property (assign) NSInteger pageControlCurrentPage;
@property (strong) IGFeedItem * delegate;
@end

@interface IGStoryMessageStoryItemWrapper : NSObject
@property (strong) IGPhoto * rawPhoto;
@property (strong) IGVideo * rawVideo;
@end

@interface IGStoryPhotoView : UIView
@property (strong) IGStoryMessageStoryItemWrapper * item;
@end

@interface IGStoryFullscreenSectionController : NSObject
@property (strong) IGFeedItem * currentStoryItem;
@property (strong) IGFeedItem * viewModel;

@property (strong) IGStoryPhotoView * currentMediaView;

- (int)_currentItemIndex;
@end

@interface IGStoryFullscreenHeaderView : UIView
@property (strong) UIButton * moreOptionsButtonIGSaverMejor;
@property (strong) IGStoryFullscreenSectionController * delegate;
@end

@interface IGSundialViewerVideoCell : IGStoryFullscreenHeaderView
@end

@interface IGTVVideoFeedViewController : UIView
@property (strong) IGFeedItem* focusedFeedItem;
@property (strong) IGFeedItem* focusedItem;
@end

@interface IGTVVideoSectionController : UIView
@property (strong) IGTVVideoFeedViewController* delegate;
@end

@interface IGTVVideoFeedActionsBarView : UIView
@property (strong) UIButton * moreOptionsButtonIGSaverMejor;
@property (strong) IGTVVideoSectionController* delegate;
@end

@interface IGStyledString : NSObject
@property (strong) NSMutableAttributedString* attributedString;
@end

@interface IGCoreTextView : UIView
@property (strong) IGStyledString* styledString;
@end

@interface IGCommetContentView : UITableViewCell
@property (strong) IGCoreTextView* commentCoreTextView;
@end

@interface IGCommentCell : UITableViewCell
@property (strong) IGCommetContentView* commentView;
@end

@interface IGProfileMenuSheetViewController : UITableViewController
@end

@interface IGProfileSheetTableViewCell : UITableViewCell
@end

static void showAlertDownloadForPostItem(IGPostItem* currentItem, NSString* username)
{
	NSString* usernameSt = username?:@"";
	@try {
		if(currentItem.user&&currentItem.user.username) {
			usernameSt = [currentItem.user.username copy];
		}
	}@catch(NSException*e){
	}
	
	NSMutableDictionary * videosQualityDown = [NSMutableDictionary dictionary];
	NSMutableDictionary * imagesQualityDown = [NSMutableDictionary dictionary];
	
	// parse media
	
	NSArray* videoVer = nil;
	if(currentItem.video) {
		if([currentItem.video respondsToSelector:@selector(videoVersionDictionaries)] && currentItem.video.videoVersionDictionaries && currentItem.video.videoVersionDictionaries.count > 0) {
			videoVer = currentItem.video.videoVersionDictionaries;
		} else if([currentItem.video respondsToSelector:@selector(videoVersions)] && currentItem.video.videoVersions && currentItem.video.videoVersions.count > 0) {
			videoVer = currentItem.video.videoVersions;
		}
	}
	
	if(videoVer && videoVer.count > 0) {		
		for(NSDictionary* videoInfoNow in videoVer) {
			NSString* height = videoInfoNow[@"height"];
			if(height!=nil) {
				videosQualityDown[[NSString stringWithFormat:@"%@", height]] = videoInfoNow[@"url"];
			}
		}
	} else if(currentItem.photo) {
		NSArray* originalImages = MSHookIvar<NSArray *>(currentItem.photo, "_originalImageVersions");
		if(originalImages && originalImages.count > 0) {
			for(IGImageURL* imageNow in originalImages) {
				imagesQualityDown[[@(imageNow.height) stringValue]] = [imageNow.url absoluteString];
			}
		}
	}
	
	NSMutableArray* actionMut = [NSMutableArray array];
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"IGSaver" message:@"Choose Action" preferredStyle:UIAlertControllerStyleAlert];
	
	void(^actionDownloadNow)(NSURL *, int, NSString *) = ^(NSURL *directURL, int mediaType, NSString *username) {
		NSString* title = [[directURL lastPathComponent] stringByDeletingPathExtension];
		NSString * pathSave = [NSTemporaryDirectory() stringByAppendingPathComponent:[directURL lastPathComponent]];
		MejorDownloadConnection* download = [[MejorDownloadConnection alloc] initWithURL:directURL path:pathSave];
		[download setFinished:^(MejorDownloadConnection* connection) {
			NSString* pathFileVideo = connection.path;

			IGSaverImportListController* import = [[IGSaverImportListController alloc] initWithPath:pathFileVideo title:title album:nil mediaType:mediaType user:username];
			
			if([[[NSUserDefaults standardUserDefaults] objectForKey:@"autoSave" inDomain:@"com.julioverne.igsaver"]?:@NO boolValue] ||
			([[[NSUserDefaults standardUserDefaults] objectForKey:@"autoSaveAcc" inDomain:@"com.julioverne.igsaver"]?:@NO boolValue] &&
			   [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@", username] inDomain:@"com.julioverne.igsaver.user"] != nil)) {
				[import addMediaToRoll];
			} else {
				[import showEdit];
			}
		}];
		
		//needed to show download progress
		[download setProgress:^(MejorDownloadConnection* connection) {
			
			DRCircularProgressView* progressView = connection.progressWindow.progressView;
			
			progressView.progressValue = (float)((float)connection.size_down/(float)connection.size);
			
			connection.progressWindow.progressLabel.text = [NSString stringWithFormat:@"%@\n%.f%@", @"Downloading...", 100*progressView.progressValue, @"%"];
			connection.progressWindow.progressLabelMinimized.text = [NSString stringWithFormat:@"%.f%@", 100*progressView.progressValue, @"%"];
			
		}];
		
		[download start];
	};
	
	
	
	if([videosQualityDown allKeys].count > 0) {
		UIAlertAction* downloadAction = [UIAlertAction actionWithTitle:@"Download Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
			UIAlertController *alertVid = [UIAlertController alertControllerWithTitle:@"IGSaver" message:@"Choose Quality" preferredStyle:UIAlertControllerStyleAlert];
			
			NSArray* ordQua = [[videosQualityDown allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:NO]]];
			
			int downloadQuality = [[[NSUserDefaults standardUserDefaults] objectForKey:@"downloadQuality" inDomain:@"com.julioverne.igsaver"]?:@(2) intValue];
			
			if(downloadQuality == 1) {
				for(NSString* quaNow in ordQua) {
					UIAlertAction* qualAction = [UIAlertAction actionWithTitle:[quaNow stringByAppendingString:@"p"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
						NSURL * directURL = [NSURL URLWithString:videosQualityDown[quaNow]];
						actionDownloadNow(directURL, 2, usernameSt);
					}];
					[alertVid addAction:qualAction];
				}
				
				UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
				[alertVid addAction:cancel];
				[topMostController() presentViewController:alertVid animated:YES completion:nil];
			} else if(downloadQuality == 2) {
				NSURL * directURL = [NSURL URLWithString:videosQualityDown[ordQua[0]]];
				actionDownloadNow(directURL, 2, usernameSt);
			}
		}];
		[actionMut addObject:downloadAction];
	}
	
	if([imagesQualityDown allKeys].count > 0) {
		UIAlertAction* downloadAction = [UIAlertAction actionWithTitle:@"Download Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
			UIAlertController *alertVid = [UIAlertController alertControllerWithTitle:@"IGSaver" message:@"Choose Quality" preferredStyle:UIAlertControllerStyleAlert];
			
			NSArray* ordQua = [[imagesQualityDown allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:NO]]];
			
			int downloadQuality = [[[NSUserDefaults standardUserDefaults] objectForKey:@"downloadQuality" inDomain:@"com.julioverne.igsaver"]?:@(2) intValue];
			
			if(downloadQuality == 1) {
				for(NSString* quaNow in ordQua) {
					UIAlertAction* qualAction = [UIAlertAction actionWithTitle:[quaNow stringByAppendingString:@"p"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
						NSURL * directURL = [NSURL URLWithString:imagesQualityDown[quaNow]];
						actionDownloadNow(directURL, 1, usernameSt);
					}];
					[alertVid addAction:qualAction];
				}
				UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
				[alertVid addAction:cancel];
				[topMostController() presentViewController:alertVid animated:YES completion:nil];
			} else if(downloadQuality == 2) {
				NSURL * directURL = [NSURL URLWithString:imagesQualityDown[ordQua[0]]];
				actionDownloadNow(directURL, 1, usernameSt);
			}
			
		}];
		[actionMut addObject:downloadAction];
	}
	
	if([actionMut count] > 0) {
		if([[[NSUserDefaults standardUserDefaults] objectForKey:@"comfirmDownload" inDomain:@"com.julioverne.igsaver"]?:@NO boolValue]) {
			for(UIAlertAction* action in actionMut) {
				[alert addAction:action];
			}
			UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
			[alert addAction:cancel];
			[topMostController() presentViewController:alert animated:YES completion:nil];
		} else {
			for(UIAlertAction* action in actionMut) {
				void (^someBlock)(id obj) = [action valueForKey:@"handler"];
				someBlock(action);
			}
		}
	}
}

static void actiontDownloadForPostItem(IGPostItem* currentItem, IGFeedItem* media, NSString* username)
{
	if(media != nil && [media respondsToSelector:@selector(items)]) {
		for(IGPostItem* currentItemNow in media.items) {
			showAlertDownloadForPostItem(currentItemNow, username);
		}
	} else {
		showAlertDownloadForPostItem(currentItem, username);
	}
}

%group IGStoryAndIGTVHooks //// ---- START HOOKS IGStoryAndIGTVHooks

%hook IGFeedItemUFICell // Instagram post hooks
%property (nonatomic, retain) UIButton * moreOptionsButtonIGSaver;
- (void)layoutSubviews
{
	%orig;
	
	UIView* vAdd = [self.contentView superview];
	
	UIView* oldBt = [vAdd viewWithTag:482];
	if(oldBt) {
		[oldBt removeFromSuperview];
	}
	self.moreOptionsButtonIGSaver = downloadButton();
	self.moreOptionsButtonIGSaver.tag = 482;
	[self.moreOptionsButtonIGSaver addTarget:self action:@selector(moreActionsIGSaver) forControlEvents:UIControlEventTouchUpInside];
	[self.moreOptionsButtonIGSaver setTitle:@" " forState:UIControlStateNormal];
	@try {
		[self.moreOptionsButtonIGSaver setTintColor:[UIColor labelColor]];
	}@catch(NSException*e){
	}
	self.moreOptionsButtonIGSaver.frame = CGRectMake(0, 0, 32, 32);
	self.moreOptionsButtonIGSaver.center = vAdd.center;
	self.moreOptionsButtonIGSaver.frame = CGRectMake(self.moreOptionsButtonIGSaver.frame.origin.x+(vAdd.frame.size.width/4), 8, self.moreOptionsButtonIGSaver.frame.size.width, self.moreOptionsButtonIGSaver.frame.size.height);
	[vAdd addSubview:self.moreOptionsButtonIGSaver];
}
%new
- (void)moreActionsIGSaver
{
	if([self respondsToSelector:@selector(delegate)] && self.delegate) {
		
		IGFeedItem* feedItem = nil;
		
		if([self.delegate respondsToSelector:@selector(media)]&&self.delegate.media) {
			feedItem = (IGFeedItem*)self.delegate.media;
		}
		
		if(!feedItem) {
			if([self.delegate respondsToSelector:@selector(feedItem)]&&self.delegate.feedItem) {
				feedItem = (IGFeedItem*)self.delegate.feedItem;
			}
		}
		
		NSArray* currentItemArr = feedItem.items;
		IGPostItem* currentItem = nil;
		
		if(currentItemArr) { 
			if([currentItemArr count] > 1) {
				currentItem = currentItemArr[self.pageControlCurrentPage];
			} else {
				currentItem = currentItemArr[0];
			}
		}
		
		NSString* usernameSt = nil;
		@try {
			usernameSt = [((IGPostItem*)feedItem).user.username copy];
		}@catch(NSException*e){
		}
		
		actiontDownloadForPostItem(currentItem, [[[NSUserDefaults standardUserDefaults] objectForKey:@"batchMode" inDomain:@"com.julioverne.igsaver"]?:@NO boolValue]?feedItem:nil, usernameSt);
	}
}
%end

%hook IGStoryFullscreenHeaderView // history hooks
%property (strong) UIButton * moreOptionsButtonIGSaverMejor;
- (void)layoutSubviews
{
	%orig;
	UIView* oldBt = [self viewWithTag:482];
	if(oldBt) {
		[oldBt removeFromSuperview];
	}
	self.moreOptionsButtonIGSaverMejor = downloadButton();
	self.moreOptionsButtonIGSaverMejor.tag = 482;
	[self.moreOptionsButtonIGSaverMejor addTarget:self action:@selector(moreActionsIGSaver) forControlEvents:UIControlEventTouchUpInside];
	[self.moreOptionsButtonIGSaverMejor setTitle:@" " forState:UIControlStateNormal];
	@try {
		[self.moreOptionsButtonIGSaverMejor setTintColor:[UIColor whiteColor]];
	}@catch(NSException*e){
	}
	self.moreOptionsButtonIGSaverMejor.frame = CGRectMake(0, 0, 32, 32);
	self.moreOptionsButtonIGSaverMejor.center = self.center;
	
	float coordXFactor = 2.6f;
	@try {
		if(self.delegate && [self.delegate respondsToSelector:@selector(currentStoryItem)]) {
			coordXFactor = 3.6f;
		}
	}@catch(NSException*e){
	}
	
	self.moreOptionsButtonIGSaverMejor.frame = CGRectMake(self.moreOptionsButtonIGSaverMejor.frame.origin.x+(self.frame.size.width/coordXFactor), -4, self.moreOptionsButtonIGSaverMejor.frame.size.width, self.moreOptionsButtonIGSaverMejor.frame.size.height);
	[self addSubview:self.moreOptionsButtonIGSaverMejor];
}
%new
- (void)moreActionsIGSaver
{
	if(self.delegate) {
		if([self.delegate respondsToSelector:@selector(currentStoryItem)]) { // story
			IGPostItem* currentItem = nil;
			if([self.delegate.currentStoryItem respondsToSelector:@selector(items)]) {
				currentItem = self.delegate.currentStoryItem.items[0];
			} else if([self.delegate.currentStoryItem respondsToSelector:@selector(media)]) {
				currentItem = self.delegate.currentStoryItem.media;
			}
			
			IGFeedItem* storyModel = nil;
			if([self.delegate respondsToSelector:@selector(viewModel)]) {
				storyModel = self.delegate.viewModel;
			}
			
			actiontDownloadForPostItem(currentItem, [[[NSUserDefaults standardUserDefaults] objectForKey:@"batchModeHistory" inDomain:@"com.julioverne.igsaver"]?:@NO boolValue]?storyModel:nil, nil);
		} else if([self.delegate respondsToSelector:@selector(currentMediaView)]) { // story
			IGPostItem* currentItem = (IGPostItem*)self.delegate.currentMediaView.item;
			actiontDownloadForPostItem(currentItem, nil, nil);
		}	
	}
}
%end


%hook IGTVVideoFeedActionsBarView // IGTV hooks
%property (strong) UIButton * moreOptionsButtonIGSaverMejor;
- (void)layoutSubviews
{
	%orig;
	UIView* oldBt = [self viewWithTag:482];
	if(oldBt) {
		[oldBt removeFromSuperview];
	}
	self.moreOptionsButtonIGSaverMejor = downloadButton();
	self.moreOptionsButtonIGSaverMejor.tag = 482;
	[self.moreOptionsButtonIGSaverMejor addTarget:self action:@selector(moreActionsIGSaver) forControlEvents:UIControlEventTouchUpInside];
	[self.moreOptionsButtonIGSaverMejor setTitle:@" " forState:UIControlStateNormal];
	@try {
		[self.moreOptionsButtonIGSaverMejor setTintColor:[UIColor whiteColor]];
	}@catch(NSException*e){
	}
	self.moreOptionsButtonIGSaverMejor.frame = CGRectMake(0, 0, 32, 32);
	self.moreOptionsButtonIGSaverMejor.center = self.center;
	self.moreOptionsButtonIGSaverMejor.frame = CGRectMake(self.moreOptionsButtonIGSaverMejor.frame.origin.x-(self.frame.size.width/20), 0, self.moreOptionsButtonIGSaverMejor.frame.size.width, self.moreOptionsButtonIGSaverMejor.frame.size.height);
	[self addSubview:self.moreOptionsButtonIGSaverMejor];
}
%new
- (void)moreActionsIGSaver
{
	if(self.delegate && self.delegate.delegate) {
		
		IGFeedItem* feedItem = nil;
		
		if([self.delegate.delegate respondsToSelector:@selector(focusedFeedItem)]) {
			feedItem = self.delegate.delegate.focusedFeedItem;
		} else if([self.delegate.delegate respondsToSelector:@selector(focusedItem)]) {
			feedItem = self.delegate.delegate.focusedItem;
		}
		
		NSString* usernameSt = nil;
		@try {
			usernameSt = [((IGPostItem*)feedItem).user.username copy];
		}@catch(NSException*e){
		}
		
		IGPostItem* currentItem = feedItem.items[0];
		
		actiontDownloadForPostItem(currentItem, nil, usernameSt);
	}
}
%end


%hook IGSundialViewerVideoCell // reels hooks
%property (strong) UIButton * moreOptionsButtonIGSaverMejor;
- (void)layoutSubviews
{
	%orig;
	UIView* oldBt = [self viewWithTag:482];
	if(oldBt) {
		[oldBt removeFromSuperview];
	}
	self.moreOptionsButtonIGSaverMejor = downloadButton();
	self.moreOptionsButtonIGSaverMejor.tag = 482;
	[self.moreOptionsButtonIGSaverMejor addTarget:self action:@selector(moreActionsIGSaver) forControlEvents:UIControlEventTouchUpInside];
	[self.moreOptionsButtonIGSaverMejor setTitle:@" " forState:UIControlStateNormal];
	@try {
		[self.moreOptionsButtonIGSaverMejor setTintColor:[UIColor whiteColor]];
	}@catch(NSException*e){
	}
	self.moreOptionsButtonIGSaverMejor.frame = CGRectMake(0, 0, 32, 32);
	self.moreOptionsButtonIGSaverMejor.center = self.center;
	self.moreOptionsButtonIGSaverMejor.frame = CGRectMake((self.frame.size.width*0.89), (self.frame.size.height * 0.12), self.moreOptionsButtonIGSaverMejor.frame.size.width, self.moreOptionsButtonIGSaverMejor.frame.size.height);
	[self addSubview:self.moreOptionsButtonIGSaverMejor];
}
%new
- (void)moreActionsIGSaver
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(video)]) {
		IGPostItem* currentItem = (IGPostItem*)((IGPostItem*)self.delegate).video;
		actiontDownloadForPostItem(currentItem, nil, nil);
	}
}
%end


%hook IGProfileMenuSheetViewController // Settings button
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return %orig + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger extraRowIndex = [self tableView:tableView numberOfRowsInSection:indexPath.section]-1;
	if(indexPath.row == extraRowIndex) {		
		IGProfileSheetTableViewCell* cell = [[%c(IGProfileSheetTableViewCell) alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SettButton"];
		cell.textLabel.text = @"IGSaver Settings";
		cell.imageView.image = [UIImage imageNamed:@"quick-reply-highlighted" inBundle:[NSBundle bundleWithIdentifier:@"com.burbn.instagram.FBSharedFramework"] compatibleWithTraitCollection:nil];
		return cell;
	}
	return %orig(tableView, indexPath);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger extraRowIndex = [self tableView:tableView numberOfRowsInSection:indexPath.section]-1;
	if(indexPath.row == extraRowIndex) {
		
		IGSaverSettingsViewController* settingsVC = [[IGSaverSettingsViewController alloc] init];
		
		UINavigationController* navCC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
		[self presentViewController:navCC animated:YES completion:nil];
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
		return;
	}	
	return %orig(tableView, indexPath);
}
%end


%end //// ---- END HOOKS IGStoryAndIGTVHooks


extern "C" char* __progname;

%ctor
{
	%init;
	
	if(strcmp(__progname, "Instagram")==0) {
		// Intagram story/IGTV hook need to be delayed to this work..
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			while(%c(IGTVVideoFeedActionsBarView)==nil) { sleep(1/2); }
			%init(IGStoryAndIGTVHooks);
		});
	}
}

