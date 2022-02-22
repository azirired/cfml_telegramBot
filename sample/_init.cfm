<cfset token="replace_your_bot_token_here">

<cfset urlTelegram="https://api.telegram.org/bot">

<!---main menu sys appointment--->
<cfset buttonMenu="{""keyboard"":[[""/daftar""],[""/temujanji""],[""/permohonan""],[""/pamer""],[""/bantuan""]],""one_time_keyboard"":true,""resize_keyboard"":true}">



<!--- date array --->
<cfset tkhArr="[""#dateformat(now(),'dd/mm/yyyy')# - Hari Ini""]">

<cfloop index="i" from="1" to="15">
	<cfif #DayofWeekAsString(DayOfWeek(dateadd('d',i,now())))# NEQ "Saturday" >
		<cfset tkhArr="#tkhArr#,[""#dateformat(dateadd('d',i,now()),'dd/mm/yyyy')# - #DayofWeekAsString(DayOfWeek(dateadd('d',i,now())))#""]">
	</cfif>
</cfloop>

<cfset buttonTarikh="{""keyboard"":[#tkhArr#,[""/cancel""]],""one_time_keyboard"":true}">

<!--- masa --->
<cfset buttonMasa="{""keyboard"":[[""08:00"",""08:30"",""09:00"",""09:30""],[""10:00"",""10:30"",""11:00"",""11:30""],[""12:00"",""12:30"",""13:00"",""13:30""],[""14:00"",""14:30"",""15:00"",""15:30""],[""16:00"",""16:30"",""17:00"",""17:30""],[""/cancel""]],""one_time_keyboard"":true}">

<!---pilihan status appointment--->
<cfset buttonStatus="{""keyboard"":[[""Confirmed""],[""Pending""],[""Cancel""]],""one_time_keyboard"":true}">



<cfset dsn="frim_appointment">
<cfset newline= chr(10)>






