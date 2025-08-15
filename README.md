# [Cordova Screen Orientation](https://github.com/okanbeydanol/cordova-plugin-screen-orientation-helper) [![Release](https://img.shields.io/npm/v/cordova-plugin-screen-orientation-helper.svg?style=flat)](https://github.com/okanbeydanol/cordova-plugin-screen-orientation-helper/releases)

Cordova plugin to set/lock the screen orientation in a common way for iOS, Android, and windows-uwp.  This plugin is based on [Screen Orientation API](http://www.w3.org/TR/screen-orientation/) so the api matches the current spec.

* This plugin is built for `cordova@^3.6`.

* This plugin currently supports Android and iOS.


## Plugin setup

Using this plugin requires [Cordova iOS](https://github.com/apache/cordova-ios) and [Cordova Android](https://github.com/apache/cordova-android).

1. `cordova plugin add cordova-plugin-screen-orientation-helper`--save



## Supported Orientations

#### portrait-primary
> The orientation is in the primary portrait mode.

#### portrait-secondary
> The orientation is in the secondary portrait mode.

#### landscape-primary
> The orientation is in the primary landscape mode.

#### landscape-secondary
> The orientation is in the secondary landscape mode.

#### portrait
> The orientation is either portrait-primary or portrait-secondary (sensor).

#### landscape
> The orientation is either landscape-primary or landscape-secondary (sensor).

#### any
>  orientation is  unlocked - all orientations are supported.


### Usage

Usage
JavaScript (Global Cordova)
After the device is ready, you can use the plugin via the global `cordova.plugins.VolumeControl` object:

```javascript
var ScreenOrientation = cordova.plugins.ScreenOrientation;

// Lock to landscape
ScreenOrientation.lock('landscape').then(() => {
    console.log('Orientation locked to landscape');
}).catch(err => {
    console.error('Failed to lock orientation:', err);
});

// Unlock all orientations
ScreenOrientation.unlock(() => {
    console.log('Orientation unlocked');
}, err => {
    console.error('Failed to unlock orientation:', err);
});

// Listen to orientation changes
ScreenOrientation.addEventListener('change', () => {
    console.log('Orientation changed to:', ScreenOrientation.type, 'Angle:', ScreenOrientation.angle);
});

// Optional: use onchange property
ScreenOrientation.onchange = () => {
    console.log('Orientation changed via onchange property:', ScreenOrientation.type);
};
```

* Check the [JavaScript source](https://github.com/okanbeydanol/cordova-plugin-screen-orientation-helper/tree/master/www/VolumeControl.js) for additional configuration.


TypeScript / ES Module / Ionic
You can also use ES module imports (with TypeScript support):

```typescript
import { ScreenOrientation } from 'cordova-plugin-screen-orientation-helper';

// Lock to portrait-primary
ScreenOrientation.lock('portrait-primary').then(() => {
    console.log('Orientation locked to portrait-primary');
}).catch(err => console.error(err));

// Unlock all orientations
ScreenOrientation.unlock(() => console.log('Orientation unlocked'));

// Listen to orientation changes
ScreenOrientation.addEventListener('change', () => {
    console.log('Orientation changed to:', ScreenOrientation.type, 'Angle:', ScreenOrientation.angle);
});
```
TypeScript Types
Type definitions are included. You get full autocompletion and type safety in TypeScript/Ionic projects.


* Check the [Typescript definitions](https://github.com/okanbeydanol/cordova-plugin-screen-orientation-helper/tree/master/www/VolumeControl.d.ts) for additional configuration.


## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cordova). (Tag `cordova`)
- If you **found a bug** or **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.



## Contributing

Patches welcome! Please submit all pull requests against the master branch. If your pull request contains JavaScript patches or features, include relevant unit tests. Thanks!

## Copyright and license

    The MIT License (MIT)

    Copyright (c) 2024 Okan Beydanol

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
