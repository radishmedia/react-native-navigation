#import <XCTest/XCTest.h>
#import "RNNRootViewController.h"
#import "RNNReactRootViewCreator.h"
#import "RNNTestRootViewCreator.h"
#import <React/RCTConvert.h>
#import "RNNNavigationOptions.h"

@interface RNNRootViewControllerTest : XCTestCase

@property (nonatomic, strong) id<RNNRootViewCreator> creator;
@property (nonatomic, strong) NSString* pageName;
@property (nonatomic, strong) NSString* containerId;
@property (nonatomic, strong) id emitter;
@property (nonatomic, strong) RNNNavigationOptions* options;
@property (nonatomic, strong) RNNRootViewController* uut;
@end

@implementation RNNRootViewControllerTest

- (void)setUp {
    [super setUp];
	self.creator = [[RNNTestRootViewCreator alloc] init];
	self.pageName = @"somename";
	self.containerId = @"cntId";
	self.emitter = nil;
	self.options = [RNNNavigationOptions new];
	self.uut = [[RNNRootViewController alloc] initWithName:self.pageName withOptions:self.options withContainerId:self.containerId rootViewCreator:self.creator eventEmitter:self.emitter];
}

-(void)testTopBarBackgroundColor_validColor{
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.topBarBackgroundColor = inputColor;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	
	XCTAssertTrue([self.uut.navigationController.navigationBar.barTintColor isEqual:expectedColor]);
}

-(void)testTopBarBackgroundColorWithoutNavigationController{
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.topBarBackgroundColor = inputColor;
	
	XCTAssertNoThrow([self.uut viewWillAppear:false]);
}

- (void)testStatusBarHidden_default {
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];

	XCTAssertFalse([self.uut prefersStatusBarHidden]);
}

- (void)testStatusBarHidden_true {
	self.options.statusBarHidden = @(1);
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	
	XCTAssertTrue([self.uut prefersStatusBarHidden]);
}

- (void)testStatusBarHidden_false {
	self.options.statusBarHidden = @(0);
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	
	XCTAssertFalse([self.uut prefersStatusBarHidden]);
}

-(void)testTitle_string{
	NSString* title =@"some title";
	self.options.title= title;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	
	[self.uut viewWillAppear:false];
	XCTAssertTrue([self.uut.navigationItem.title isEqual:title]);
}

-(void)testTitle_default{
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	
	[self.uut viewWillAppear:false];
	XCTAssertNil(self.uut.navigationItem.title);
}

-(void)testTopBarTextColor_validColor{
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.topBarTextColor = inputColor;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.navigationController.navigationBar.titleTextAttributes[@"NSColor"] isEqual:expectedColor]);
}

-(void)testScreenBackgroundColor_validColor{
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.screenBackgroundColor = inputColor;
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.view.backgroundColor isEqual:expectedColor]);
}

-(void)testTopBarTextFontFamily_validFont{
	NSString* inputFont = @"HelveticaNeue";
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	self.options.topBarTextFontFamily = inputFont;
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont fontWithName:inputFont size:20];
	XCTAssertTrue([self.uut.navigationController.navigationBar.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
}

-(void)testTopBarTextFontFamily_invalidFont{
	NSString* inputFont = @"HelveticaNeueeeee";
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	self.options.topBarTextFontFamily = inputFont;
	XCTAssertThrows([self.uut viewWillAppear:false]);
}

-(void)testTopBarHideOnScroll_true {
	NSNumber* hideOnScrollInput = @(1);
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	self.options.topBarHideOnScroll = hideOnScrollInput;
	[self.uut viewWillAppear:false];
	XCTAssertTrue(self.uut.navigationController.hidesBarsOnSwipe);
}

-(void)testTopBarButtonColor {
	NSNumber* inputColor = @(0xFFFF0000);
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	self.options.topBarButtonColor = inputColor;
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.navigationController.navigationBar.tintColor isEqual:expectedColor]);
}

<<<<<<< HEAD
-(void)testTopBarTranslucent {
	NSNumber* topBarTranslucentInput = @(0);
	self.options.topBarTranslucent = topBarTranslucentInput;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	XCTAssertFalse(self.uut.navigationController.navigationBar.translucent);
}



=======
>>>>>>> bc6234ecc511aac84ef67cd65b0b87d76eec4d44
@end