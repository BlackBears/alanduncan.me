---
layout: post
title: Set an ivar via the Objective-C runtime
date: 2013-10-02 15:37
comments: false
categories: [objc, programming]
tags: Objective-C, Programming
---

Generally, I don't like to use a lot of runtime trickery, swizzling and the like - but there are use cases where knowing how to do it can solve an immediate problem.

For my current project, I've temporarily incorporated a hidden feature that is brought up by a application-wide `UIGestureRecognizer` added to the main window.  It allows me to 
do things with the Core Data objects that I don't necessarily want to expose to the user; but I'd like to be able to test quickly in real-world settings.  For example, deleting 
all of a particular group of managed objects so that I can test what empty table views look like.  Or generating sample data so that I can see what really full table views look like.

One function that I needed to test in the field was a long-running timer.  Not wanting to wait 15 or 30 minutes for an event to happen, I decided to create a developer-only functionality that would advance the timer to within 15 seconds of completion.  Not something I want to expose to the end-user; but nice to have for testing.  To do this, we need to manipulate an ivar `_currentSeconds`, resetting its value to 15.  But let's take a more general case with a class named `Foo`.

``` objectivec
@interface Foo : NSObject

@property (nonatomic, readonly) NSInteger count;

@end

@implementation Foo
@end
```

Since the class interface only provides readonly access to the `count` property and its backing ivar `_count`, we can't use the public interface to manipulate `count`.  But the Objective-C runtime API will let us do so:

``` objectivec
#import <objc/runtime.h>

//	create the instance whose count property we'll change
Foo *myFoo = [[Foo alloc] init];
```

Now get a reference to the `Ivar` via the runtime:

``` objectivec
Ivar ivar = class_getInstanceVariable(Foo.class, "_count");
assert(ivar);
```

Now the tricky part, since we're changing a scalar, we can't use `object_setIvar` because it takes an `id`.  So we're forced to set the ivar by using an offset into the class ivar layout.  Something like this:

``` objectivec
int *ivarPtr = (int *)((uint8_t *)myFoo + ivar_getOffset(ivar));
```
This is perfectly legal under reference counted memory management; but under ARC, it won't compile because ARC doesn't know how to manage the memory of the pointer we've created.  The workaround is this:

``` objectivec
CFTypeRef myFooRef = CFBridgingRetain(myFoo);
int *ivarPtr = (int *)((uint8_t *)myFooRef + ivar_getOffset(ivar));
```

Now all that's left is to set our ivar and release the `CFTypeRef`

```objectivec
*ivarPtr = 15;
CFBridgingRelease(myFooRef);
```

Showing the whole thing:

``` objectivec
@interface Foo : NSObject
@property (nonatomic, readonly) NSInteger counter;
@end

@implementation Foo

@end

//	Now we'll access the ivar from another class

#import <objc/runtime.h>

Foo *myFoo = [[Foo alloc] init];

Ivar ivar = class_getInstanceVariable(Foo.class, "_counter");
assert(ivar);
CFTypeRef myFooRef = CFBridgingRetain(myFoo);
int *ivarPtr = (int *)((uint8_t *)myFooRef + ivar_getOffset(ivar));
*ivarPtr = 15;
CFBridgingRelease(myFooRef);
```

See also: 

- [Assigning Objective-C object in a void* pointer with ARC](http://stackoverflow.com/questions/18234651/assigning-objective-c-object-in-a-void-pointer-with-arc) _[Stack Overflow]_
- [ivars and fundamental types](http://www.cocoabuilder.com/archive/cocoa/294230-ivars-and-fundamental-types.html) _[Cocoabuilder]_

_Comments? I'm `@NSBum`_