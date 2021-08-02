How do you deploy Kaldi on Android? We might need to train the Kaldi model on the server, use the model and Kaldi 's code to inference , but the Kaldi code can't run on Android directly , so we need to compile the Kaldi code into a dependency package that can run on Android, based on the Kaldi model and the Kaldi 's code, We can then write Android code to generate the APK file.

Vosk is a speech recognition toolkit (https://github.com/alphacep/vosk-api)  and the vosk-android-demo is an Android demo based on vosk implementation（https://github.com/alphacep/vosk-android-demo）It can help us conveniently deploy the Kaldi model on mobile phones. We can change the Kaldi model based on vosk-Android-Demo，change java UI, or add kaldi-android aar to dependencies depending on the equipment you are deploying（x86, arm64 ， armv7，armv8）

[vosk-android-demo](https://github.com/alphacep/vosk-android-demo) is Updated to latest android API .We can simply change our model on this basis and deploy Kaldi on Android.

I'm going to go through the detailed process of deploying Kaldi on Android using Vosk-Android-demo. In addition, IF we are deploying Kaldi on other Android devices (ARMV8), I will walk through the steps to generate an Android archive AAR and the process of deploying it.

Use the existing vosk-Android-Demo deployment method

1.Install the Android studio

Launch Android Studio, open preferences, and search for SDK. After opening the SDK Tools TAB, we need to install some build Tools:

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/1.png)

- `Android SDK Build-Tools`: 30.0.3
- `NDK`: 22.0.7026061
- `Android SDK Command-line Tools`: 4.0.0
- `CMake`: 3.10.2.4988404
- `Android Emulator`
- `Android SDK Platform-tool`

2.Download the source code of Vosk-Android-Demo

Find the following path vosk-android-demo-master\models\src\main\assets\model-en-us

According to the required files in the path, replace the files in the Kaldi model trained by us

The required files are as follows:

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/2.png)

It's important to note that you put words.txt here ：

vosk-android-demo-master\models\src\main\assets\model-en-us\graph

Otherwise, the compilation will  fails

Note that HCLr. fst, Ge.fst is different from HCLG.fst

We need to generate it using the utils/mkgraph_lookahead.sh script

eg: utils/mkgraph_lookahead.sh /home3/asrxiv/w2021/deliverables/release/msf-scdf-cs-june2021/data/local/lang /home3/yuhang001/w2021/kaldi/egs/aishell/s5/tdnnf-bias

Error if the script is running, we need to run the kaldl/tools/extras/install_opengrm.sh  installation time if an error, We need to put kaldl/tools/openfst - 1.7.2 soft connection to kaldl/tools/extras/openfst

3.We also need an Android phone (virtual machine performance is low). Enable developer options on the phone, and enable USB debugging options. When you're ready, connect your phone to your computer.

4.Import the Vosk-Android-Demo project in Android Studio

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/3.png)

Note that if our model is large, we need to change gradle.properties

add :

org.gradle.jvmargs=-Xmx3048m -XX:MaxPermSize=3048m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/4.png)

5.Compile and run

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/5.png)

6.Click install on your phone and the demo will run

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/6.png)

二，How do we generate AARS based on device generation

1.We first need to install the appropriate version of the SDK has the NDK, here according to [the] vosk - API version 

android-sdk_r24

wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz

tar -zxvf [android-sdk_r24.4.1-linux.tgz](http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz)

Modifying  ~/.bashre

```
export ANDROID_HOME=/usr/local/android-sdk-linux
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
```

After installing the SDK, you need to update some dependency packages

cd  $yourpath/android-sdk-linux/tools

运行android

Find the required dependencies and install them. 28.0.3 is required

![Alt text](https://github.com/yuhangear/kaldi-android/blob/main/img/7.png)

android-ndk21：

wget https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip

unzip  [android-ndk-r21e-linux-x86_64.zip](https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip)

ln -s yourpath/android-ndk-r21e  $sdkdir/ndk-bundle

Maybe  you need to have Java installed

wget  https://www.oracle.com/webapps/redirect/signon?nexturl=https://download.oracle.com/otn/java/jdk/8u301-b09/d3c52aa6bfa54d3ca74e617f18309292/jdk-8u301-linux-i586.tar.gz

Unpack jdk-8u301-linux-x64.tar.gz

export JAVA_HOME=/media/mipitalk/home/yyh2001/w2021/android/temp/java/jdk1.8.0_301 export JRE_HOME=$JAVA_HOME/jre export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH

1. git clone https://github.com/alphacep/vosk-api

   git checkout 0.3.21

   cd android

   Modify the local.properties file

   sdk.dir=/media/mipitalk/home/yyh2001/w2021/android/temp/sdk/android-sdk-linux

   Next, we need to modify build.gradle [build-kaldi.sh](http://build-kaldi.sh/) according to our requirements.

   build.gradle:

   Change abiFilters ‘armeabi-v7a’ to abiFilters ‘arm64-v8a’.

   [build-kaldi.sh](http://build-kaldi.sh/): 

   If we just need the Kaldi code on arm64,

   “for arch in arm64 x86 ; do ” changed to “for arch in arm64  ; do”

   Run gradle build

   会生成android/build/outputs/aar。这就是我们需要的

2. Add aar to our previous Vosk-Android-Demo project for Windows

   - Create the aars file in the project root directory
   - Put the android/build/outputs/aar/vosk-android-release.aar in the Aars folder and name it kaldi-android-5.2.aar
   - Create build.gradle in the aars directory

   ```
   configurations.maybeCreate("default")
   artifacts.add("default", file('kaldi-android-5.2.aar'))
   ```

   - change settings.gradele 
   - add: include ':models', ':app' ,':aars'

4. Next, you can import the project in Android Studio