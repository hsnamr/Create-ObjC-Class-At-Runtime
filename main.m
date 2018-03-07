//
//  main.m
//
//  Created by Hussian Al-Amri on 03/07/2018.
//  Copyright © 2018 H4n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>

Class Car;

NSNumber *wheelsGetter(id self, SEL _cmd) {
    Ivar ivar = class_getInstanceVariable(Car, "_wheels");
    return object_getIvar(self, ivar);
}

void wheelsSetter(id self, SEL _cmd, NSNumber* newCount) {
    Ivar ivar = class_getInstanceVariable(Car, "_wheels");
    id oldCount = object_getIvar(self, ivar);
    if (oldCount != newCount) object_setIvar(self, ivar, [newCount copy]);
}

void createClass() {
    // allocate class
    Car =  objc_allocateClassPair([NSObject class], "Car", 0);
    
    // add iVar
    class_addIvar(Car, "_wheels", sizeof(size_t), log2(sizeof(size_t)), @encode(NSNumber*));
    
    // add property
    objc_property_attribute_t type = { "T", "@\"NSNumber\"" };
    objc_property_attribute_t backingivar  = { "V", "_wheels" };
    objc_property_attribute_t attrs[] = { type, backingivar };
    class_addProperty(Car, "wheels", attrs, 2);
    
    // add getter method
    class_addMethod(Car, @selector(wheels), (IMP)wheelsGetter, "@@:");
    
    // add setter method
    class_addMethod(Car, @selector(setWheels:), (IMP)wheelsSetter, "v@:@");

    // register class
    objc_registerClassPair(Car);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        createClass();
        
        id car = [[Car alloc] init];
        
        [car performSelector:@selector(setWheels:) withObject:@4];
        
        NSLog(@"%@", [car performSelector:@selector(wheels)]);
    }
    return 0;
}
