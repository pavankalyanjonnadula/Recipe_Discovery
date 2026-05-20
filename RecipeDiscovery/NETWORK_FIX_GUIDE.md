# Fixing Network Connection Issues

## Problem
The app is stuck on the loading screen because iOS blocks HTTP connections by default for security reasons. TheMealDB API uses `www.themealdb.com` which may have network restrictions.

## Solution: Configure App Transport Security

You need to add network permissions to your app's Info.plist through Xcode:

### Steps to Fix:

#### Method 1: Using Xcode UI (Recommended)

1. **Open the project in Xcode**
2. **Select the RecipeDiscovery target** (click on the project name in the left panel)
3. **Go to the "Info" tab**
4. **Add a new key:**
   - Click the **"+"** button to add a new row
   - Type: `App Transport Security Settings` (or select it from dropdown)
   - This will create a Dictionary

5. **Inside "App Transport Security Settings", add:**
   - Click the **"+"** next to "App Transport Security Settings"
   - Add key: `Allow Arbitrary Loads`
   - Set Type: `Boolean`
   - Set Value: `YES`

6. **Clean and rebuild:**
   - Press `⌘⇧K` (Product → Clean Build Folder)
   - Press `⌘R` to run

#### Method 2: Edit Info.plist directly (Alternative)

If Xcode auto-generates Info.plist, you can add a custom plist:

1. Right-click on `RecipeDiscovery` folder → New File
2. Select **Property List** → Name it `Info.plist`
3. Add the following structure:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
</dict>
</plist>
```

4. In your target settings, point "Info.plist File" to this file

### Debug Logs Added

I've added extensive logging to help debug the issue. When you run the app, check Xcode's Console (⌘⇧Y) for:

- 🌐 API call URLs
- 📊 HTTP status codes
- 📄 Raw API responses
- ✅ Success messages
- ❌ Error messages

### Expected Console Output (Success):

```
📡 Loading recipes for letter: a
🌐 Making API call to: https://www.themealdb.com/api/json/v1/1/search.php?f=a
📊 HTTP Status Code: 200
📄 Raw API Response (first 500 chars): {"meals":[{"idMeal":"53049"...
✅ Successfully decoded 4 meals
✅ Loaded 4 recipes for letter: a
```

### Common Errors You Might See:

#### Error 1: NSURLErrorDomain Code=-1200
```
❌ Network error: Error Domain=NSURLErrorDomain Code=-1200 "An SSL error has occurred"
```
**Solution:** Enable App Transport Security as described above

#### Error 2: NSURLErrorDomain Code=-1009
```
❌ Network error: Error Domain=NSURLErrorDomain Code=-1009 "The Internet connection appears to be offline"
```
**Solution:** Check your internet connection and simulator network settings

#### Error 3: Decoding Error
```
❌ Decoding error: ...
```
**Solution:** Check the Recipe model matches the API response

### Quick Fix Steps:

1. **Stop the app** (if running)
2. **In Xcode:** Select RecipeDiscovery target → Info tab
3. **Add:** App Transport Security Settings → Allow Arbitrary Loads = YES
4. **Clean:** ⌘⇧K
5. **Run:** ⌘R
6. **Check Console:** ⌘⇧Y (look for emoji logs)

### Alternative: Test API Connection

You can test if the API is accessible from Terminal:

```bash
curl "https://www.themealdb.com/api/json/v1/1/search.php?f=a"
```

If this works but the app doesn't, it's definitely an App Transport Security issue.

### Still Not Working?

If the issue persists after adding App Transport Security settings:

1. **Check Xcode Console** for specific error messages
2. **Verify Internet Connection** in the simulator
3. **Restart the simulator**
4. **Clean Derived Data:** 
   - Go to `~/Library/Developer/Xcode/DerivedData`
   - Delete the `RecipeDiscovery-*` folder
   - Rebuild

### Production Note

For production apps, instead of `Allow Arbitrary Loads`, you should use domain-specific exceptions:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>www.themealdb.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>
```

This is more secure as it only allows connections to specific domains.

