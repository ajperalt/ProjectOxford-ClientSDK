// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license.
//
// Microsoft Cognitive Services (formerly Project Oxford): https://www.microsoft.com/cognitive-services
//
// Microsoft Cognitive Services (formerly Project Oxford) GitHub:
// https://github.com/Microsoft/ProjectOxford-ClientSDK
//
// Copyright (c) Microsoft Corporation
// All rights reserved.
//
// MIT License:
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#import <XCTest/XCTest.h>
#import "MPOFaceSDK.h"
#import "MPOTestConstants.h"
#import "MPOTestHelpers.h"
@interface SimilarTestCase : XCTestCase
@property NSDictionary *testDataDict;
@end

@implementation SimilarTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    
    self.testDataDict = [MPOTestHelpers detectWithDict:@{
                                                         @"chris1": kChrisImageName1,
                                                         @"chris2": kChrisImageName2,
                                                         @"chris3": kChrisImageName3,
                                                         @"alberto1": kAlbertoImageName1,
                                                         @"john1": kJohnImageName1,
                                                         }];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimilar {

    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithSubscriptionKey:kOxfordApiKey];
    
    [client findSimilarWithFaceId:self.testDataDict[@"chris1"] faceIds:[NSArray arrayWithObjects:self.testDataDict[@"chris2"], self.testDataDict[@"chris3"], self.testDataDict[@"alberto1"], self.testDataDict[@"michelle1"], nil] completionBlock:^(NSArray<MPOSimilarFace *> *collection, NSError *error) {
        
        if (error) {
            XCTFail(@"fail");
        }
        else {
            XCTAssertEqual(collection.count, 2);
            
            NSMutableArray *faceIds = [[NSMutableArray alloc] init];
            
            for (MPOSimilarFace *similarFace in collection) {
                [faceIds addObject:similarFace.faceId];
            }
                        
            XCTAssertTrue([faceIds containsObject:self.testDataDict[@"chris2"]]);
            XCTAssertTrue([faceIds containsObject:self.testDataDict[@"chris3"]]);

        }
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
}

@end
