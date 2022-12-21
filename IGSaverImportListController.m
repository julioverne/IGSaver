#import "IGSaverImportListController.h"
#import <Photos/Photos.h>

static NSURL* fixURLRemoteOrLocalWithPath(NSString* inPath)
{
	NSString* inPathRet = inPath;
	if([inPathRet hasPrefix:@"file:"]) {
		NSString* try1 = [[NSURL URLWithString:inPathRet] path];
		if(try1) {
			inPathRet = try1;
		}
		if([inPathRet hasPrefix:@"file:"]) {
			inPathRet = [inPathRet substringFromIndex:5];
		}
	}
	while([inPathRet hasPrefix:@"//"]) {
		inPathRet = [inPathRet substringFromIndex:1];
	}
	NSURL* retURL = [inPathRet hasPrefix:@"/"]?[NSURL fileURLWithPath:inPathRet]:[NSURL URLWithString:inPathRet];
	return retURL;
}

static NSString * formatFileSizeFromBytes(long long fileSize)
{
    return [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
}

@interface NSUserDefaults ()
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)removeObjectForKey:(id)arg1 inDomain:(id)arg2;
//- (id)volatileDomainForName:(id)arg1;
@end

@implementation IGSaverImportListController
@synthesize path, tags, imageview, activityViewController;
- (void)showEdit
{
	@try {
	
		imageview = [[UIImageView alloc] init];
		imageview.tag = 468;
		imageview.contentMode = UIViewContentModeScaleAspectFit;
		[imageview setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		if(path) {
			imageview.image = [UIImage imageWithContentsOfFile:path];
		}
		
		UINavigationController* navCon; 
		if(!navCon) {
			navCon = [[UINavigationController alloc] initWithNavigationBarClass:[UINavigationBar class] toolbarClass:[UIToolbar class]];
		}
		[navCon setViewControllers:@[self] animated:NO];
		[topMostController() presentViewController:navCon animated:YES completion:nil];
	} @catch (NSException * e) {
	}
}

- (void)resolveAlbumName
{
	@try {
		NSString* defaultForMedia = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IGSaver-default-media-%@", self.tags[@"kind"]] inDomain:@"com.julioverne.igsaver"];
		if(defaultForMedia != nil) {
			self.tags[@"album"] = [defaultForMedia copy];
		}
		NSString* defaultForUser = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@", self.tags[@"username"]] inDomain:@"com.julioverne.igsaver.user"];
		if(defaultForUser != nil) {
			self.tags[@"album"] = [defaultForUser copy];
		}
	} @catch (NSException * e) {
	}
}

- (id)initWithPath:(NSString*)pathSt title:(NSString*)titleSt album:(NSString*)albumSt mediaType:(int)mediaType user:(NSString*)user;
{
	self = [super init];
	if(self) {
		self.path = pathSt;
		self.tags = [[NSMutableDictionary alloc] init];
		@try {
			self.tags[@"title"] = titleSt?:@"";
			self.tags[@"kind"] = @(mediaType);
			self.tags[@"album"] = albumSt?:@"Instagram";
			
			self.tags[@"username"] = [user?:@"" copy];
			
			@try {
				NSURL *fileURL = fixURLRemoteOrLocalWithPath(self.path);
				NSNumber *fileSizeValue = nil;
				[fileURL getResourceValue:&fileSizeValue forKey:NSURLFileSizeKey error:nil];
				self.tags[@"size"] = @([fileSizeValue?:@(0) intValue]);
			} @catch (NSException * e) {
			}
			
			[self resolveAlbumName];
			
		} @catch (NSException * e) {
		}	
	}
	return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	__strong UIBarButtonItem* kBTClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeEdit)];
	__strong UIBarButtonItem* kBTSettings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(openSettings)];
	@try {
		kBTClose.tintColor = [UIColor labelColor];
		kBTSettings.tintColor = [UIColor labelColor];
	}@catch(NSException*e){
	}
	kBTClose.tag = 4;	
	if (self.navigationController.navigationBar.backItem == NULL) {
		self.navigationItem.leftBarButtonItems = @[kBTClose, kBTSettings];
	}
}
- (void)openSettings
{
	UIViewController* settingsVC = [[objc_getClass("IGSaverSettingsViewController") alloc] init];
	UINavigationController* navCC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
	[self presentViewController:navCC animated:YES completion:nil];
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
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Save To Camera Roll"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Save To Camera Roll" forKey:@"label"];
		[specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Album Name"
                                              target:self
											  set:@selector(setPreferenceValue:specifier:)
											  get:@selector(readPreferenceValue:)
                                              detail:Nil
											  cell:PSEditTextCell
											  edit:Nil];
		[spec setProperty:@"album" forKey:@"key"];
        [specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Save As Default"
					      target:self
						 set:NULL
						 get:NULL
					      detail:Nil
						cell:PSLinkCell
						edit:Nil];
		spec->action = @selector(showAlertSaveFolderName);
		[specifiers addObject:spec];
		
		
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Media Info"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Media Info" forKey:@"label"];
		[specifiers addObject:spec];
		
		if([self.tags[@"kind"] intValue] == 1) {
			spec = [PSSpecifier preferenceSpecifierNamed:@"Image"
					      target:self
						 set:NULL
						 get:NULL
					      detail:Nil
						cell:PSTitleValueCell
						edit:Nil];
			[spec setProperty:@"Image" forKey:@"key"];
			[spec setProperty:@"" forKey:@"default"];
			[specifiers addObject:spec];
		}
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Type"
											  target:self
												 set:NULL
												 get:@selector(readPreferenceValue:)
											  detail:Nil
												cell:PSSegmentCell
												edit:Nil];		
		[spec setValues:@[@(1), @(2), ] titles:@[@"Image",	@"Video",]];
		[spec setProperty:@"kind" forKey:@"key"];
		[specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Title"
					      target:self
						 set:NULL
						 get:@selector(readPreferenceValue:)
					      detail:Nil
						cell:PSTitleValueCell
						edit:Nil];
		[spec setProperty:@"title" forKey:@"key"];
		[specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Account"
					      target:self
						 set:NULL
						 get:@selector(readPreferenceValue:)
					      detail:Nil
						cell:PSTitleValueCell
						edit:Nil];
		[spec setProperty:@"username" forKey:@"key"];
		[specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Type"
					      target:self
						 set:NULL
						 get:@selector(fileExt)
					      detail:Nil
						cell:PSTitleValueCell
						edit:Nil];
		[specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Size"
					      target:self
						 set:NULL
						 get:@selector(fileSizeFormat)
					      detail:Nil
						cell:PSTitleValueCell
						edit:Nil];
		[specifiers addObject:spec];
		
		
		
		spec = [PSSpecifier emptyGroupSpecifier];
		[spec setProperty:[NSString stringWithFormat:@"Source:\n%@", self.path] forKey:@"footerText"];
		[specifiers addObject:spec];
		
		spec = [PSSpecifier emptyGroupSpecifier];
        [spec setProperty:@"IGSaver © 2021" forKey:@"footerText"];
        [specifiers addObject:spec];
		_specifiers = [specifiers copy];
	}
	return _specifiers;
}
- (id)fileSizeFormat
{
	return formatFileSizeFromBytes([self.tags[@"size"]?:@(0) intValue]);
}
- (id)fileExt
{
	return [[self.path?:@"" pathExtension] uppercaseString];
}
- (void)setRightButton
{
	__strong UIBarButtonItem* kBTShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
	__strong UIBarButtonItem* kBTRight = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(importFileNow)];
	@try {
		kBTShare.tintColor = [UIColor labelColor];
		kBTRight.tintColor = [UIColor labelColor];
	}@catch(NSException*e){
	}
	kBTRight.tag = 4;
	self.navigationItem.rightBarButtonItems = @[kBTRight, kBTShare];	
}
- (void)shareAction
{
	activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[fixURLRemoteOrLocalWithPath(self.path)] applicationActivities:nil];
	[self presentViewController:activityViewController animated:YES completion:nil];
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"IGSaver";
	[self setRightButton];
	static __strong UIRefreshControl *refreshControl;
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

- (void)showAlertSaveFolderName
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"IGSaver" message:[NSString stringWithFormat:@"Set Album Name \"%@\" As Default For:", self.tags[@"album"]] preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* Action2 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Media Type \"%@\"", [self.tags[@"kind"]?:@(0) intValue]==1?@"Image":@"Video"]style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", self.tags[@"album"]] forKey:[NSString stringWithFormat:@"IGSaver-default-media-%@", self.tags[@"kind"]] inDomain:@"com.julioverne.igsaver"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self resolveAlbumName];
		[self refresh:nil];
	}];
	[alert addAction:Action2];
	
	UIAlertAction* Action3 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Account Name \"%@\"", self.tags[@"username"]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", self.tags[@"album"]] forKey:[NSString stringWithFormat:@"%@", self.tags[@"username"]] inDomain:@"com.julioverne.igsaver.user"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self resolveAlbumName];
		[self refresh:nil];
	}];
	[alert addAction:Action3];
	
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
		[self refresh:nil];
	}];
	[alert addAction:cancel];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier
{
	self.tags[[specifier identifier]] = [value copy];
}
- (id)readPreferenceValue:(PSSpecifier*)specifier
{
	return self.tags[[specifier identifier]];
}
- (void)_returnKeyPressed:(id)arg1
{
	[self.view endEditing:YES];
	
	[super _returnKeyPressed:arg1];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)addMediaToRoll
{
    void (^saveBlock)(PHAssetCollection *assetCollection) = ^void(PHAssetCollection *assetCollection) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *assetChangeRequest = nil;
			
			int sourceType = [self.tags[@"kind"] intValue];
			if(sourceType == 1) {
				assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:fixURLRemoteOrLocalWithPath(self.path)];
            } else if(sourceType == 2) {
				assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fixURLRemoteOrLocalWithPath(self.path)];
            }
			
			PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];

        } completionHandler:^(BOOL success, NSError *error) {
        }];
    };
	
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"localizedTitle = %@", self.tags[@"album"]];
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];
    if (fetchResult.count > 0) {
        saveBlock(fetchResult.firstObject);
    } else {
        __block PHObjectPlaceholder *albumPlaceholder;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.tags[@"album"]];
            albumPlaceholder = changeRequest.placeholderForCreatedAssetCollection;

        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumPlaceholder.localIdentifier] options:nil];
                if (fetchResult.count > 0) {
                    saveBlock(fetchResult.firstObject);
                }
            }
        }];
    }
}
	
- (void)importFileNow
{
	[self.view endEditing:YES];
	[self addMediaToRoll];
	[self closeEdit];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([self.tags[@"kind"] intValue]==1 && indexPath.section==1 && indexPath.row==0) {
		UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Image"];
		cell.textLabel.text = nil;
		cell.textLabel.textColor = [UIColor whiteColor];
		
		imageview.frame = cell.bounds;
		
		UIView* removeOld = [cell viewWithTag:468];
		if(removeOld) {
			[removeOld removeFromSuperview];
		}
		[cell addSubview:imageview];
		
		return cell;
	}
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
- (double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([self.tags[@"kind"] intValue]==1 && indexPath.section==1 && indexPath.row==0) {
		return 200.0f;
	}
	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	if([self.tags[@"kind"] intValue]==1 && indexPath.section==1 && indexPath.row==0) {
		[self shareAction];
	}
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end
