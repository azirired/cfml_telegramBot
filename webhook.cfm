<!--- index file for webhook URL 
Configure telegram bot guna setwebhook
File ni perlu diletakkan diserver anda dan set webhook url kepada
alamat fail ini.

Contoh:
Set webhook pada telegram bot taip url dibawah pada browser untuk set webhook

https://api.telegram.org/bot<token>/setWebhook?url=https://your_server_address/webhook.cfm
.: webhook.cfm adalah file ini.

--->

<!--- return code 200 --->
<cfheader statusCode="200" statusText="OK" />	

<!---------------- WEBHOOK START HERE------------------->
<cfset reply = DeserializeJSON(ToString(StructFind(GetHttpRequestData(), "content"))) >

<cfset message_text = reply.message.text  /> <!---text daripada user--->
<cfset chat_id = reply.message.from.id /> <!---id telegram bot user --->
<!---------------- End WEBHOOK ------------------------->		

<cfoutput>	
  <cfif reply EQ "/hi">
    <cfhttp url="https://api.telegram.org/bot#bot_token#/sendMessage?chat_id=#chat_id#&text=Hello. Apa khabar?">
  <cfelseif reply EQ "/mula">
    <cfhttp url="https://api.telegram.org/bot#bot_token#/sendMessage?chat_id=#chat_id#&text=Sila klik pada menu">
  </cfif>
</cfoutput>
