//
//  M2AppDelegate.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2AppDelegate.h"
@import AppCenter;
@import AppCenterAnalytics;
@import AppCenterCrashes;
@import AppCenterPush;
@interface M2AppDelegate()<MSPushDelegate,MSCrashesDelegate>
@end
@implementation M2AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[MSAppCenter setLogUrl:@"https://in-staging-south-centralus.staging.avalanch.es"];
    [MSPush setDelegate:self];
    [MSCrashes setDelegate:self];
    [MSAppCenter start:@"c55344fd-a53d-45d6-96a6-6167c83757f2" withServices:@[
                                                                                 [MSAnalytics class],
                                                                                 [MSCrashes class],
                                                                                 [MSPush class]                                                                                 ]];
    NSUUID *installId = [MSAppCenter  installId];
    NSString *deviceId = [installId UUIDString];
    MSCustomProperties *customProperties = [MSCustomProperties new];
    [customProperties setString:@"red" forKey:@"color"];
    [customProperties setNumber:@(9) forKey:@"score"];
    [MSAppCenter setCustomProperties:customProperties];
   
    [MSCrashes setUserConfirmationHandler:(^(NSArray<MSErrorReport *> *errorReports) {
        
        // Your code to present your UI to the user, e.g. an UIAlertController.
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Sorry about that!"
                                              message:@"Do you want to send an anonymous crash report so we can fix the issue?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController
         addAction:[UIAlertAction actionWithTitle:@"Don't send"
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction *action) {
                                              [MSCrashes notifyWithUserConfirmation:MSUserConfirmationDontSend];
                                          }]];
        
        [alertController
         addAction:[UIAlertAction actionWithTitle:@"Send"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *action) {
                                              [MSCrashes notifyWithUserConfirmation:MSUserConfirmationSend];
                                          }]];
        
        [alertController
         addAction:[UIAlertAction actionWithTitle:@"Always send"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *action) {
                                              [MSCrashes notifyWithUserConfirmation:MSUserConfirmationAlways];
                                          }]];
        // Show the alert controller.
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        return YES; // Return YES if the SDK should await user confirmation, otherwise NO.
    })];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)push:(MSPush *)push didReceivePushNotification:(MSPushNotification *)pushNotification {
    NSString *message = pushNotification.message;
    for (NSString *key in pushNotification.customData) {
        message = [NSString stringWithFormat:@"%@\n%@: %@", message, key, [pushNotification.customData objectForKey:key]];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pushNotification.title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (NSArray<MSErrorAttachmentLog *> *)attachmentsWithCrashes:(MSCrashes *)crashes
                                             forErrorReport:(MSErrorReport *)errorReport {
    MSErrorAttachmentLog *attachment1 = [MSErrorAttachmentLog attachmentWithText:@"Hello world!" filename:@"hello.txt"];
    MSErrorAttachmentLog *attachment2 = [MSErrorAttachmentLog attachmentWithBinary:[@"Fake image" dataUsingEncoding:NSUTF8StringEncoding] filename:@"fake_image.jpeg" contentType:@"image/jpeg"];
    return @[ attachment1, attachment2 ];
}
@end
