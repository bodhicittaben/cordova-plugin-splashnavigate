/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVSplashNavigate.h"
#import <Cordova/CDVViewController.h>
#import "MainViewController.h"
#import "CDVSplashScreen.h"

@implementation CDVSplashNavigate

- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDidLoad) name:CDVPageDidLoadNotification object:self.webView];
    _shouldHandleLoad = FALSE;
}

- (void)pageDidLoad
{
    if (_shouldHandleLoad == TRUE) {
        _shouldHandleLoad = FALSE;

        CDVSplashScreen *screen = [self.commandDelegate getCommandInstance:@"SplashScreen"];

        if (screen == nil) {
            NSLog(@"ERROR: SplashNavigate requires SplashScreen, please add it using > cordova plugin add org.apache.cordova.splashscreen");
        }

        [screen hide:nil];
    }
}


- (void)go:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *pluginResult = nil;
    NSString *url = [command argumentAtIndex: 0];

    if (url != nil && [url length] > 0) {
        MainViewController *mainView = (MainViewController*)self.viewController;
        mainView.startPage = url;

        NSURLRequest* appReq = [NSURLRequest requestWithURL:[NSURL URLWithString:mainView.startPage]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:20.0];
        [mainView.webView loadRequest:appReq];
        _shouldHandleLoad = TRUE;
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
