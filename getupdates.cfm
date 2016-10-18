<!--- untuk dapatkan mesej yang dihantar ke telegram bot anda--->
<cfparam name="offset" default="0">
<cfparam name="bot_token" default="{your bot token id}">

<cfoutput>
  <cfhttp url="https://api.telegram.org/bot#bot_token#/getupdates?offset=#offset#" />
</cfoutput>

<!--- output dalam bentuk json --->
