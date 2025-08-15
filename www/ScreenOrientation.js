function ScreenOrientation() {
    if (!window.OrientationLockType) {
        window.OrientationLockType = {
            'portrait-primary': 1,
            'portrait-secondary': 2,
            'landscape-primary': 4,
            'landscape-secondary': 8,
            portrait: 3,
            landscape: 12,
            any: 15
        };
    }
    this.orientationMask = 1;
    setOrientationProperties(this);
    var self = this;
    window.addEventListener('orientationchange', function () {
        setOrientationProperties(self);
        if (typeof self._onChangeListener === 'function') {
            self._onChangeListener();
        }
    }, true);
}

ScreenOrientation.prototype.setOrientation = function (orientation, success, error) {
    const mask = window.OrientationLockType[orientation];
    if (mask === undefined) {
        if (error) error(new Error('Invalid orientation: ' + orientation));
        return;
    }

    this.orientationMask = mask;
    cordova.exec(success, error, 'ScreenOrientation', 'screenOrientation', [mask]);
};

ScreenOrientation.prototype.lock = function (orientation) {
    const self = this;
    return new Promise((resolve, reject) => {
        if (!window.OrientationLockType.hasOwnProperty(orientation)) {
            const err = new Error();
            err.name = 'NotSupportedError';
            reject(err);
        } else {
            self.setOrientation(orientation, () => resolve('Orientation set'), e => reject(e));
        }
    });
};

ScreenOrientation.prototype.unlock = function (success, error) {
    this.setOrientation('any', success, error);
};

ScreenOrientation.prototype.addEventListener = function (event, listener) {
    if (event === 'change') this._onChangeListener = listener;
};

ScreenOrientation.prototype.removeEventListener = function (event, listener) {
    if (event === 'change' && this._onChangeListener === listener) this._onChangeListener = null;
};

Object.defineProperty(ScreenOrientation.prototype, 'onchange', {
    set: function (listener) { this.addEventListener('change', listener); },
    get: function () { return this._onChangeListener || null; },
    enumerable: true
});

function setOrientationProperties(obj) {
    let angle = 0;
    let type = 'portrait-primary';

    if (window.screen && window.screen.orientation) {
        angle = window.screen.orientation.angle || 0;
        type = window.screen.orientation.type || 'portrait-primary';
    } else if (typeof window.orientation === 'number') {
        switch (window.orientation) {
            case 0: type = 'portrait-primary'; break;
            case 90: type = 'landscape-primary'; break;
            case 180: type = 'portrait-secondary'; break;
            case -90: type = 'landscape-secondary'; break;
            default: type = 'portrait-primary';
        }
        angle = window.orientation;
    }

    obj.type = type;
    obj.angle = angle;
}

module.exports = new ScreenOrientation();
module.exports.ScreenOrientation = module.exports;

// For ES module import support
if (typeof window !== 'undefined' && window.cordova && window.cordova.plugins) {
    window.cordova.plugins.screenOrientation = module.exports;
}