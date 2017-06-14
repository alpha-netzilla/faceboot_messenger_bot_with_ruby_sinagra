# Faceboot messenger bot
This is a Facebook Messenger Bot written in Ruby with the help of Sinatra.


#How to Use

 1. Prepare your facebook messanger platform at https://developers.facebook.com/docs/messenger-platform

 2. Install required gems  
    ```ruby
    $ gem install  
    ```

 3. Run the bot  
    ```ruby
    $ PAGE_TOKEN=<PAGE_TOKEN> VERIFY_TOKEN=<YOUR_VERIFY_TOKEN> CHAT_BOT_ID=<CHAT_BOT_ID> ruby bot.rb
    ```
    PAGE_TOKEN  : Like a password which we can see on the facebook developper page.  
    VERIFY_TOKEN: An arbitrary keyword which we can creat on the facebook developer page.  
    CHAT_BOT_ID : Equals a facebook page id which we can see on the facebook bage.  

 4. Test the bot  
   Say something like "test aaa", "test bbb", "test ccc", "test ddd" whose comments are for test scenario.


#Author
http://alpha-netzilla.blogspot.com/
