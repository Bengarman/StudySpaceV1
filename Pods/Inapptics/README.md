# Inapptics

[Inapptics](https://inapptics.com) is a mobile analytics platform that helps app creators understand how people use their app and improve their product based on proactive insights.

## Getting started

In order to use this SDK, you will need an active Inapptics account. So, before going forward, register an account at [https://inapptics.com](https://inapptics.com), create an app and obtain an app token.

Inapptics SDK supports 2 types of integration:

[CocoaPods Integration](#user-content-integration-1) | [Manual Integration](#user-content-integration-2)

### CocoaPod Integration <a id="integration-1"></a>

**Step 1:** Create a `Podfile` in your project's root directory, if it doesn't exist yet.

**Step 2:** Add the `Inapptics` pod in `Podfile` under your desired target:

```ruby
target 'YOUR-TARGET' do
    ...
    pod 'Inapptics'
end
```

**Step 3:** Run `pod repo update && pod install` in terminal.

**Step 4:** Open your project using the generated `*.xcworkspace` file.

**Step 5:** Finally, edit your **AppDelegate** file: 

Import the `Inapptics module`

Add Inapptics initialization code in `-application:didFinishLaunchingWithOptions:` method:

**ObjectiveC**

```ObjectiveC
@import Inapptics;

...

+ (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // Override point for customization after application launch.

    ...
    
    [Inapptics letsGoWithAppToken:@"YOUR_APP_TOKEN"];
    return YES;
}
```

**Swift**

```Swift
import Inapptics

...

func application(application: UIApplication, didFinishLaunchingWithOptions
                 launchOptions: [NSObject: AnyObject]?) -> Bool
{
    // Override point for customization after application launch.

    ...
    
    Inapptics.letsGo(withAppToken: "YOUR_APP_TOKEN")
    return true
}
```

![Step 6](https://inapptics.com/images/docs/ios/integration/manual/app-delegate.png)



### Manual Integration  <a id="integration-2"></a>

**Step 1:** Click [here](https://s3.amazonaws.com/inapptics-cdn-ko0ld/sdk/manual/Inapptics.framework.zip) to download inapptics SDK.

**Step 2:** Extract downloaded archive file.

**Step 3:** Open your project for integration in Xcode.

**Step 4:** Select your project target and open **General** tab. Drag and drop `Inapptics.framework` into the project **Embedded Binaries**

![Step 4](https://inapptics.com/images/docs/ios/integration/manual/embedded_binaries.png)

**Step 5:** Check the **'Copy items if needed'** checkbox.

![Step 5](https://inapptics.com/images/docs/ios/integration/manual/copy_items.png)

**Step 6:** Open your project target's **Build Phases** and add a new **Run Script Phase** with the following code snippet:

![Step 6](https://inapptics.com/images/docs/ios/integration/manual/build_phase.png)

**Step 7:**  Finally, edit your **AppDelegate** file: 

Import the `Inapptics module`

Add Inapptics initialization code in `-application:didFinishLaunchingWithOptions:` method:

**ObjectiveC**

```ObjectiveC
@import Inapptics;

...

+ (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // Override point for customization after application launch.

    ...
    
    [Inapptics letsGoWithAppToken:@"YOUR_APP_TOKEN"];
    return YES;
}
```

**Swift**

```Swift
import Inapptics

...

func application(application: UIApplication, didFinishLaunchingWithOptions
                 launchOptions: [NSObject: AnyObject]?) -> Bool
{
    // Override point for customization after application launch.

    ...

    Inapptics.letsGo(withAppToken: "YOUR_APP_TOKEN")
    return true
}
```
          
![Step 7](https://inapptics.com/images/docs/ios/integration/manual/app-delegate.png)

## License

Inapptics License
Copyright (c) 2017 Inapptics Inc.

Detailed content in [Terms of use](https://inapptics.com/terms-of-use/)

