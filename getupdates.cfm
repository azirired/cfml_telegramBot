<!--- untuk dapatkan mesej yang dihantar ke telegram bot anda--->
<cfparam name="offset" default="0"> <!--- offset adalah untuk baca mesej yang terbaru berdasarkan no UPDATE_ID yang di setkan--->
<cfparam name="bot_token" default="{your bot token id}">

<cfoutput>
  <cfhttp url="https://api.telegram.org/bot#bot_token#/getupdates?offset=#offset#" />
</cfoutput>

<!--- 
##########################
Contoh output dalam bentuk json 
##########################
{
    "ok": true,
    "result": [
        
        {
            "update_id": 1234567810,
            "message": {
                "message_id": 2,
                "from": {
                    "id": 1234567890,
                    "first_name": "John",
                    "last_name": "Doe",
                    "username": "JohnDoe"
                },
                "chat": {
                    "id": 1234567890,
                    "first_name": "John",
                    "last_name": "Doe",
                    "username": "JohnDoe",
                    "type": "private"
                },
                "date": 1459957722,
                "text": "Hello Bot!"
            }
      ]
}
--->

