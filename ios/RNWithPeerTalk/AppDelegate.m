/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import <Peertalk/PTChannel.h>
#import <Peertalk/PTUSBHub.h>
#import "FBPortForwardingServer.h"

@implementation AppDelegate
#if TARGET_OS_SIMULATOR || !defined(DEBUG)
#else
{
  FBPortForwardingServer *_portForwardingServer;
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#if TARGET_OS_SIMULATOR || !defined(DEBUG)
#else
  _portForwardingServer = [FBPortForwardingServer new];
  [_portForwardingServer forwardConnectionsFromPort:8081];
  [_portForwardingServer listenForMultiplexingChannelOnPort:8025];
  
  jsCodeLocation = [RCTBundleURLProvider jsBundleURLForBundleRoot:@"index"
                                                     packagerHost:@"127.0.0.1.xip.io"
                                                        enableDev:[[RCTBundleURLProvider sharedSettings] enableDev]
                                               enableMinification:[[RCTBundleURLProvider sharedSettings] enableMinification]];
#endif

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"RNWithPeerTalk"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
