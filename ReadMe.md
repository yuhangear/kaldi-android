## Deploy the Kaldi model to Android

How do we deploy Kaldi on Android? We might need to train the Kaldi model on the server, use the model and Kaldi 's code to inference , but the Kaldi code can't run on Android directly , so we need to compile the Kaldi code into a dependency package that can run on Android, based on the Kaldi model and the Kaldi 's code, We can then write Android code to generate the APK file.

Vosk is a speech recognition toolkit (https://github.com/alphacep/vosk-api)  and the vosk-android-demo is an Android demo based on vosk implementation（https://github.com/alphacep/vosk-android-demo）It can help us conveniently deploy the Kaldi model on mobile phones. We can change the Kaldi model based on vosk-Android-Demo，change java UI, or add kaldi-android aar to dependencies depending on the equipment you are deploying（x86, arm64 ， armv7，armv8）

[vosk-android-demo](https://github.com/alphacep/vosk-android-demo) is Updated to latest android API .We can simply change our model on this basis and deploy Kaldi on Android.

and https://github.com/yuhangear/kaldi-android/tree/main/vosk-android which modify the form of hypothesis occurrence of kaldi-android

I'm going to go through the detailed process of deploying Kaldi on Android using Vosk-Android-demo. In addition, IF we are deploying Kaldi on other Android devices (ARMV8), I will walk through the steps to generate an Android archive AAR and the process of deploying it.



**Use the existing vosk-Android-Demo deployment method**

1. Install the Android studio 

Launch Android Studio, open preferences, and search for SDK. After opening the SDK Tools TAB, we need to install some build Tools:

- ###### download and install Android Studio

  - https://redirector.gvt1.com/edgedl/android/studio/install/2020.3.1.23/android-studio-2020.3.1.23-windows.exe

- install some build Tools

  - open : File->Settings->Appearance&Behavior->System Settings->Android SDK
  - select:
    - Android11.0(R)
    - `Android SDK Build-Tools`: 30.0.3
    - `NDK`: 22.0.7026061
    - `Android SDK Command-line Tools`: 4.0.0
    - `CMake`: 3.10.2.4988404
    - `Android Emulator`
    - `Android SDK Platform-tool`

  ![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/1.png)

2. Download the source code of Vosk-Android-Demo
   - download: https://codeload.github.com/yuhangear/kaldi-android/zip/refs/heads/main

Find the following path vosk-android-demo-master\models\src\main\assets\model-en-us

According to the required files in the path, find the files in the Kaldi model trained by us . if you don't have the trained model. you can use the official existing models which repackaged Librispeech model from [Kaldi](http://kaldi-asr.org/models/m13):  https://alphacephei.com/vosk/models/vosk-model-en-us-librispeech-0.2.zip

The required files are as follows:

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/2.png)

and put the files in the right place. There are some photos of the need files ( models\src\main\assets\model-en-us)

There are a few things to note:

- put "words.txt" here ：vosk-android-demo-master\models\src\main\assets\model-en-us\graph

- "splice_opts" in ivector should be renamed as "splice.conf"

- if "HCLG.fst" is too big to put it in phone , we can use "HCLr. fst" and "Ge.fst" instead.
  - we can use "utils/mkgraph_lookahead.sh" to generate the files: 
  - eg: utils/mkgraph_lookahead.sh  $lang_path $tdnnf_path
  - if the script is running, we need to run the kaldl/tools/extras/install_opengrm.sh  installation time if an error, We need to put kaldl/tools/openfst - 1.7.2 soft connection to kaldl/tools/extras/openfst
  
- If the error  "Dimension mismatch: source features have dimension 91 and LDA #cols is 281" occurs.we should modify mfcc.conf

  - --num-mel-bins=40     # similar to Google's setup.
    --sample-frequency=16000  #modify according to the sampling rate

    --num-ceps=40     # there is no dimensionality reduction.

    --low-freq=40    # low cutoff frequency for mel bins

    --high-freq=-200 # high cutoff frequently,relative to Nyquist of 8000 (=3800)

3. Import the Vosk-Android-Demo project in Android Studio

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/3.png)

Note that if our model is large, we need to change gradle.properties

add :

org.gradle.jvmargs=-Xmx3048m -XX:MaxPermSize=3048m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/4.png)

4. We also need an Android phone (virtual machine performance is low). Enable developer options on the phone, and enable USB debugging options. When you're ready, connect your phone to your computer.

5. Compile and run

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/5.png)

6. Click install on your phone and the demo will run.(./video/demo.mp4)

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/6.png)







**That's the main work, and the next step is to deploy the model on some other device**

**二，How do we generate AARS based on device generation**

1.We first need to install the appropriate version of the SDK has the NDK in the linux , here according to the vosk - API version 

- install android-sdk_r24
- wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
- tar -zxvf [android-sdk_r24.4.1-linux.tgz](http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz)
- Modifying  ~/.bashre

```
export ANDROID_HOME=/usr/local/android-sdk-linux
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
```

After installing the SDK, you need to update some dependency packages

+ cd  $yourpath/android-sdk-linux/tools
+ run android
+ Find the required dependencies and install them. 28.0.3 is required

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/7.png)

2.  In install android-ndk21：

+ wget https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip

+ unzip  [android-ndk-r21e-linux-x86_64.zip](https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip)

+ ln -s yourpath/android-ndk-r21e  $sdkdir/ndk-bundle

+ Maybe  you need to have Java installed

+ wget  https://www.oracle.com/webapps/redirect/signon?nexturl=https://download.oracle.com/otn/java/jdk/8u301-b09/d3c52aa6bfa54d3ca74e617f18309292/jdk-8u301-linux-i586.tar.gz

+ Unpack jdk-8u301-linux-x64.tar.gz

+ export JAVA_HOME=/media/mipitalk/home/yyh2001/w2021/android/temp/java/jdk1.8.0_301 export JRE_HOME=$JAVA_HOME/jre export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH



3. compile vosk-api

   + git clone https://github.com/alphacep/vosk-api
   + git checkout 0.3.21
   + cd android
   + Modify the local.properties file
   + sdk.dir=/media/mipitalk/home/yyh2001/w2021/android/temp/sdk/android-sdk-linux
   + Next, we need to modify build.gradle [build-kaldi.sh](http://build-kaldi.sh/) according to our requirements.
   +  in "build.gradle"Change abiFilters ‘armeabi-v7a’ to abiFilters ‘arm64-v8a’.
   + in "[build-kaldi.sh](http://build-kaldi.sh/):" If we just need the Kaldi code on arm64,“for arch in arm64 x86 ; do ” changed to “for arch in arm64  ; do”
   + Run gradle build
   + Generates the android/build/outputs/aar. That's what we need

4. Add aar to our previous Vosk-Android-Demo project for Windows

   - Create the aars file in the project root directory
   - Put the android/build/outputs/aar/vosk-android-release.aar in the Aars folder and name it kaldi-android-5.2.aar
   - Create build.gradle in the aars directory

   ```
   configurations.maybeCreate("default")
   artifacts.add("default", file('kaldi-android-5.2.aar'))
   ```

   - change settings.gradele 
   - add: include ':models', ':app' ,':aars'

5. Next, you can import the project in Android Studio



