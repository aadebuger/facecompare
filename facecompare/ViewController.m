//
//  ViewController.m
//  facecompare
//
//  Created by aadebuger on 2018/7/28.
//  Copyright © 2018年 aadebuger. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking/AFNetworking.h"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
 
    [self formupload];
    
    
}

-(NSMutableData *) formdata:(NSData *)imageData1 face2:(NSData *)imageData2 {
    
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    // [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"api_key"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Ur"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"api_secret"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"NHqlh"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData1) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=face1.jpg\r\n", @"image_file1"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData1];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=face2.jpg\r\n", @"image_file2"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData2];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

-(void) formupload {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    NSString *urlString = @"https://api-cn.faceplusplus.com/facepp/v3/compare";
    
  //  urlString =@"http://www.httpbin.org/post";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString *filePath1 = [[NSHomeDirectory()
                           stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"openMacIcon.png"];
    NSString *filePath=@"/Users/aadebuger/GEXT/vision/cvlr/2.jpg";
    
    NSString *fileName = [filePath lastPathComponent];
    NSData   *fileData      = [NSData dataWithContentsOfFile:filePath];
    NSData   *fileData2      = [NSData dataWithContentsOfFile:@"/Users/aadebuger/GEXT/vision/cvlr/3.jpg"];
    
    
    NSString *boundary = @"unique-consistent-string";
    /*
    NSMutableData *dataSend = [[NSMutableData alloc] init];
    
    [dataSend appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataSend appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataSend appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [dataSend appendData:fileData];
    
    [dataSend appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [dataSend appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     
    NSMutableData *dataSend =[self formdata:fileData face2:fileData2];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataSend];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *sessionUploadTask = [session uploadTaskWithRequest:request fromData:dataSend completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSString *responseStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"data =%@",responseStr);
        
        [session finishTasksAndInvalidate];
        
    }];
    [sessionUploadTask resume];
    
    NSLog(@"exit");
}
-(void) upload1{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
