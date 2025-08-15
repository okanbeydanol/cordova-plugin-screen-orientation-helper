package com.okanbeydanol.screenOrientation;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;

import org.json.JSONArray;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.pm.ActivityInfo;

public class ScreenOrientation extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
        if ("screenOrientation".equals(action)) {
            return handleScreenOrientation(args, callbackContext);
        }

        callbackContext.error("Action not recognised");
        return false;
    }

    @SuppressLint("SourceLockedOrientationActivity")
    private boolean handleScreenOrientation(JSONArray args, CallbackContext callbackContext) {
        if (args.length() == 0) {
            callbackContext.error("Orientation mask not provided");
            return false;
        }

        final int mask = args.optInt(0, -1);
        if (mask == -1) {
            callbackContext.error("Invalid orientation mask");
            return false;
        }

        final Activity activity = cordova.getActivity();

        cordova.getActivity().runOnUiThread(() -> {
            switch (mask) {
                case 1:  // portrait-primary
                    activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
                    break;
                case 2:  // portrait-secondary
                    activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT);
                    break;
                case 4:  // landscape-primary
                    activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
                    break;
                case 8:  // landscape-secondary
                    activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE);
                    break;
                case 3:  // portrait-primary | portrait-secondary
                    activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
                    break;
                case 12: // landscape-primary | landscape-secondary
                    activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
                    break;
                case 15: // any
                    activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_FULL_SENSOR);
                    break;
                default:
                    callbackContext.error("Invalid orientation mask: " + mask);
                    return;
            }

            callbackContext.success();
        });

        return true;
    }
}
