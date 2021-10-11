English:

The process of deploying the model to Android

+ Install Android-Studio on Windows
  + https://redirector.gvt1.com/edgedl/android/studio/install/2020.3.1.23/android-studio-2020.3.1.23-windows.exe
+ Copy the project files to the Windows system
  + https://github.com/yuhangear/kaldi-android/archive/refs/heads/main.zip
+ Package the trained model on the Linux server side with scripts
  + https://github.com/yuhangear/kaldi-android/blob/main/pack_model.sh
+ Place the packed model directory in the project files subdirectory on the Window computer
  + kaldi-android\vosk-android\models\src\main\assets\model-en-us
+ Import the project file in Android-Studio, wait for the project build (the first time will automatically download the dependency package)
+ Put your phone into developer mode, connect it to your computer using USB, and hit Run



中文

部署模型到android的流程

+ 在windows安装android-studio
  + https://redirector.gvt1.com/edgedl/android/studio/install/2020.3.1.23/android-studio-2020.3.1.23-windows.exe
+ 拷贝项目到window系统上
  + https://github.com/yuhangear/kaldi-android/archive/refs/heads/main.zip
+ 在linux服务器端打包训练好了的模型
  + https://github.com/yuhangear/kaldi-android/blob/main/pack_model.sh
+ 将打包好的模型目录放到window电脑上项目文件子目录中
  + kaldi-android\vosk-android\models\src\main\assets\model-en-us
+ android-studio中导入项目文件，等待项目build（第一次会自动下载依赖包）
+ 将手机调至开发者模式，使用usb连接电脑，点击运行