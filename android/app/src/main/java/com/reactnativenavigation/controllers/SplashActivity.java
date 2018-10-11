package com.reactnativenavigation.controllers;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.LayoutRes;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.reactnativenavigation.NavigationApplication;
import com.reactnativenavigation.react.*;
import com.reactnativenavigation.utils.CompatUtils;

public abstract class SplashActivity extends AppCompatActivity {
    public static boolean isResumed = false;
    public static SplashActivity instance = null;

    public static void start(Activity activity) {
        Intent intent = activity.getPackageManager().getLaunchIntentForPackage(activity.getPackageName());
        if (intent == null) return;
        intent.setAction(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_LAUNCHER);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        instance = this;
        LaunchArgs.instance.set(getIntent());
        setSplashLayout();
        IntentDataHandler.saveIntentData(getIntent());
    }

    @Override
    protected void onResume() {
        super.onResume();
        isResumed = true;

        if (NavigationApplication.instance.getReactGateway().hasStartedCreatingContext()) {
            if (CompatUtils.isSplashOpenedOverNavigationActivity(this, getIntent())) {
                finish();
                return;
            }

            //  radish 서버를 통해 push 진입한 경우
            boolean isPushFromServer = getIntent() != null && getIntent().getExtras() != null && getIntent().getExtras().getString("deeplink") != null;

            //  braze를 통해 push 진입한 경우
            boolean isPushFromBraze = getIntent() != null && getIntent().getExtras() != null && getIntent().getExtras().getBoolean("push");

            //  진입 경로가 deeplink인 경우
            boolean isDeeplink = getIntent() != null && getIntent().getData() != null;

            //  진입 경로에 상관없이 deeplink값을 갖고 있는 경우에만 해당 함수를 실행한다.
            if(!isPushFromServer && !isPushFromBraze && !isDeeplink ) {
                //  refresh 기능 함수
                NavigationApplication.instance.getEventEmitter().sendAppLaunchedEvent();
            }

            if(getIntent().getData() != null) {
                try {
                    //  deeplink data를 event로 react-native에 전달한다.(해당 방법이 아닌경우 app이 foreground인 경우 해당값을 react-native의 branch handler에서 전달받지 못함.)
                    NavigationApplication.instance.getReactGateway().getReactContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("deeplinkEvent", getIntent().getData().toString());
                } catch (Exception e) {

                }
            }

            if ((isPushFromServer || isPushFromBraze || isDeeplink ) && NavigationApplication.instance.clearHostOnActivityDestroy(this)) {
                overridePendingTransition(0, 0);
                finish();
            }

            return;
        }

        if (ReactDevPermission.shouldAskPermission()) {
            ReactDevPermission.askPermission(this);
            return;
        }

        if (NavigationApplication.instance.isReactContextInitialized()) {
            NavigationApplication.instance.getEventEmitter().sendAppLaunchedEvent();
            return;
        }

        // TODO I'm starting to think this entire flow is incorrect and should be done in Application
        NavigationApplication.instance.startReactContextOnceInBackgroundAndExecuteJS();
    }

    @Override
    protected void onPause() {
        super.onPause();
        isResumed = false;
    }

    private void setSplashLayout() {
        final int splashLayout = getSplashLayout();
        if (splashLayout > 0) {
            setContentView(splashLayout);
        } else {
            setContentView(createSplashLayout());
        }
    }

    /**
     * @return xml layout res id
     */
    @LayoutRes
    public int getSplashLayout() {
        return 0;
    }

    /**
     * @return the layout you would like to show while react's js context loads
     */
    public View createSplashLayout() {
        View view = new View(this);
        view.setBackgroundColor(Color.WHITE);
        return view;
    }
}
