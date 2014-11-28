//
//  melitestTests.m
//  melitestTests
//
//  Created by Diego de Paz Sierra on 11/28/14.
//  Copyright (c) 2014 depa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ServiciosWeb.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Articulo.h"
#import "ResumenArticulo.h"

@interface melitestTests : XCTestCase

@end

@implementation melitestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void) testBuscarArticulo {
    
    NSString * filtro = @"ipod";
    [Expecta setAsynchronousTestTimeout:10000];
    __block  NSDictionary * resultInfo = nil;
    __block id errorResponse = nil;
    
    [[ServiciosWeb sharedInstance] buscarProductos:filtro completion:^(NSDictionary *dictionary) {
        resultInfo = (NSDictionary *)dictionary;
        NSLog(@"Resultado : %@", resultInfo);
        
        NSDictionary * results = dictionary[@"results"];
        
        for (NSDictionary * result in results){
            ResumenArticulo * articulo = [ResumenArticulo initWithDictionary:result];
            XCTAssertNotNil(articulo.itemId);
        }

        
        
    } failedBlock:^(NSString *error) {
        resultInfo = (NSDictionary *)error;
        NSLog(@"error : %@", error);
    }];
    
    expect(resultInfo).willNot.beNil();
    expect(errorResponse).will.beNil();
}

- (void) testDetalleArticulo {
    
    NSString * itemId = @"MLA533657947";
    [Expecta setAsynchronousTestTimeout:10000];
    __block  NSDictionary * resultInfo = nil;
    __block id errorResponse = nil;
    //XCTAssertNotNil(articulo.itemId);
    [[ServiciosWeb sharedInstance] detalleProducto:itemId completion:^(NSDictionary *dictionary) {
        resultInfo = (NSDictionary *)dictionary;
        NSLog(@"Resultado : %@", resultInfo);
        
        
        Articulo * articulo = [Articulo initWithDictionary:dictionary];
        XCTAssertNotNil(articulo.itemId);
        
        
    } failedBlock:^(NSString *error) {
        resultInfo = (NSDictionary *)error;
        NSLog(@"error : %@", error);
    } ];

    
    expect(resultInfo).willNot.beNil();
    expect(errorResponse).will.beNil();
}

@end
