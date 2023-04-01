# WeChat_ChatGPT
微信+ChatGPT自动回复机器人


## 注意: 该代码为Mac版微信,效果为iPhone
### 自动回复均为ChatGPT接口
### Veision:  3.7.0

### 支持功能
1. 支持[^群聊]被艾特时候自动回复，无视昵称群备注等
    - 被艾特 + 问题 = 自动回复文字
    - 被艾特 + 图片暗语 = 自动回复图片
2. 自动回复时候会自动[^引用]发起问题的消息，可以更方便的看见回复谁的问题
3. 增加自己问自己[^私聊]也可以回复的模式，方便自己调试GPT
4. 支持[^暗语]功能，支持自己在群里发送暗语,调起自动回复  
    - 文字暗语 = 自动回复文字
    - 图片暗语 = 自动回复图片

### 效果
<img src="https://github.com/xsmvp/WeChat_ChatGPT/blob/main/Other/Images/IMG_0002.PNG" width="50%"/>
<img src="https://github.com/xsmvp/WeChat_ChatGPT/blob/main/Other/Images/IMG_0002.PNG" width="50%"/>
<img src="https://github.com/xsmvp/WeChat_ChatGPT/blob/main/Other/Images/IMG_0002.PNG" width="50%"/>


### 用法

#### Config.h
  - `<ChatGPT_Api_key>` = 配置API_Key [^必须]
  - `<codeWords>` = 文字暗语
  - `<pictureCodeWords>` = 图片暗语

配置后,运行项目,即可使用
如果不用了之后打开微信失败，请运行项目中[^./Orther/Uninstall.sh]文件即可恢复到原始文件
  
