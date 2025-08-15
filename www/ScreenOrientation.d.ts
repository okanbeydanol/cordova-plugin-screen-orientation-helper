declare namespace CordovaPlugins {
  type OrientationType =
    | 'portrait-primary'
    | 'portrait-secondary'
    | 'landscape-primary'
    | 'landscape-secondary'
    | 'portrait'
    | 'landscape'
    | 'any';

  interface ScreenOrientation {
    type: string;
    angle: number;
    orientationMask: number;
    setOrientation(
      orientation: OrientationType,
      success?: () => void,
      error?: (err: any) => void
    ): void;
    lock(orientation: OrientationType): Promise<string>;
    unlock(success?: () => void, error?: (err: any) => void): void;
    addEventListener(event: 'change', listener: () => void): void;
    removeEventListener(event: 'change', listener: () => void): void;
    onchange: (() => void) | null;
  }
}

interface CordovaPlugins {
  ScreenOrientation: CordovaPlugins.ScreenOrientation;
}

interface Cordova {
  plugins: CordovaPlugins;
}

declare let cordova: Cordova;

export const ScreenOrientation: CordovaPlugins.ScreenOrientation;
export as namespace ScreenOrientation;
declare const _default: CordovaPlugins.ScreenOrientation;
export default _default;