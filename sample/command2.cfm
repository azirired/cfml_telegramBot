
<!--- step 2 --->

<cfquery name="Qselect" datasource="#dsn#">
	SELECT *
	FROM tbl_commandPos
	WHERE telegram_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#aa.chat.id#">
</cfquery>

<cfif Qselect.recordcount EQ 0>
	<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=Input tak valid. Sila hubungi Admin&reply_markup=#buttonMenu#">
	<cfabort>
</cfif>


<cfoutput query="Qselect">
	#commandTxt#<br/><br/>
	<cfif commandTxt EQ "DAFTAR">
		
		<!---semak kewujudan pegawai dalam tblPegawai--->
		<cfquery name="Qpegawai" datasource="#dsn#">
		SELECT *
		FROM tbl_pegawai
		WHERE noic = <cfqueryparam cfsqltype="cf_sql_varchar" value="#aa.text#">
		</cfquery>

		<!---jika pegawai wujud--->
		<cfif Qpegawai.recordcount GT 0>
			<cfquery name="QDaftar" datasource="#dsn#">
				insert into tbl_daftar(
					telegram_id,
					noic,
					telegram_firstname,
					tkh_register,
					uuid

				) values (
					'#aa.chat.id#',
					'#Qpegawai.noic#',
					'#aa.from.first_name#',
					#now()#,
					'#uuidPos#'
				)
			</cfquery>
			
			<cfset txt="Berjaya mendaftar#newline##newline#Sys Appointment FRIM">

			<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt#&reply_markup=#buttonMenu#" /> 
				
			<!---delete status dlm tbl_commandPos untuk clearkan temp db--->
			<cfquery name="Qdel" datasource="#dsn#">
				DELETE FROM tbl_commandPos
				WHERE telegram_id = '#aa.from.id#'
			</cfquery>


		<cfelse>
			<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=Anda tiada dalam senarai. Pendaftaran tidak berjaya. Sila hubungi Admin&reply_markup=#buttonMenu#">
		</cfif>

	<!--- button new temujanji--->	
	<cfelseif commandTxt EQ "TEMUJANJI">
		
		<!---asingkan tarikh dgn nama hari--->
		<cfset arrTarikh = listToArray(#aa.text#,"-")>
		<cfset arrTarikh = arrTarikh[1]>

		<!---dapatkan day,month,year pada mesej yg dihantar--->
		<cfset arrTarikh = listToArray(arrTarikh,"/")>
		<!---tukar mesej yg dihantar kepada format date--->
		<cfset arrTarikh = createDate(arrTarikh[3], arrTarikh[2], arrTarikh[1])>


		<!--- insert data to db tbl_appointment--->
		<cfquery name="Qinsert" datasource="#dsn#">
			insert into tbl_appointment(
					Date_App,
					uuidPos

				) values (
					
					#arrTarikh#,
					'#uuidPos#'
				)
		</cfquery>
		
		<!---update tbl_CommandPos--->
		<cfif #Qselect.recordcount# GT 0>
			<cfquery name="Qupdate" datasource="#dsn#">
					
				UPDATE tbl_commandPos
				SET  
					tkh_state=#now()#,
					commandTxt='TEMUJANJIMASA',
					uuidPos='#uuidPos#'
				WHERE telegram_id=#aa.chat.id#
			
			</cfquery>

				<cfset txt="Pilih masa temujanji :">
				<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt#&reply_markup=#buttonMasa#">

		</cfif>
		<!---end update tbl_commandPos--->
	
	<!---TEMUJANJIMASA--->
	<cfelseif commandTxt EQ "TEMUJANJIMASA">

		<cfquery name="Qget" datasource="#dsn#">
			SELECT *
			FROM tbl_appointment
			WHERE uuidPos='#uuidPos#'
		</cfquery>

		<!---dapatkan masa dro mesej yg dihantar--->
		<cfset arrMasa = listToArray(#aa.text#,":")>
		<!---tukar mesej kepada time format--->
		<cfset arrMasa= createTime(arrMasa[1], arrMasa[2] , 00)>
		
		<!--- save kedalam db masa yang dihantar--->
		<cfquery name="Qupdate" datasource="#dsn#">
			UPDATE tbl_appointment
			SET  
				masa = #arrMasa#
			WHERE uuidPos='#uuidPos#'
		</cfquery>

		<!--- update tbl_commandPos--->
		<cfquery name="Qupdate" datasource="#dsn#">
				
			UPDATE tbl_commandPos
			SET  
				tkh_state=#now()#,
				commandTxt='TEMUJANJISUBJEK',
				uuidPos='#uuidPos#'
			WHERE telegram_id=#aa.chat.id#
		
		</cfquery>

		<cfset txt="Masukkan subjek :">
		<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt#">
		
		<!--- end update tbl_commandPos--->

	<!---TEMUJANJISUBJEK--->
	<cfelseif commandTxt EQ "TEMUJANJISUBJEK">

		<cfquery name="Qget" datasource="#dsn#">
			SELECT *
			FROM tbl_appointment
			WHERE uuidPos='#uuidPos#'
		</cfquery>

		
		<!--- save kedalam db masa yang dihantar--->
		<cfquery name="Qupdate" datasource="#dsn#">
			UPDATE tbl_appointment
			SET  
				subject = '#aa.text#'
			WHERE uuidPos='#uuidPos#'
		</cfquery>

		<!--- update tbl_commandPos--->
		<cfquery name="Qupdate" datasource="#dsn#">
				
			UPDATE tbl_commandPos
			SET  
				tkh_state=#now()#,
				commandTxt='TEMUJANJILOKASI',
				uuidPos='#uuidPos#'
			WHERE telegram_id=#aa.chat.id#
		
		</cfquery>

		<cfset txt="Masukkan lokasi :">
		<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt#">
		
		<!--- end update tbl_commandPos--->

	<!---TEMUJANJILOKASI--->
	<cfelseif commandTxt EQ "TEMUJANJILOKASI">

		<cfquery name="Qget" datasource="#dsn#">
			SELECT *
			FROM tbl_appointment
			WHERE uuidPos='#uuidPos#'
		</cfquery>

		
		<!--- save kedalam db masa yang dihantar--->
		<cfquery name="Qupdate" datasource="#dsn#">
			UPDATE tbl_appointment
			SET  
				lokasi = '#aa.text#'
			WHERE uuidPos='#uuidPos#'
		</cfquery>

		<!--- update tbl_commandPos--->
		<cfquery name="Qupdate" datasource="#dsn#">
				
			UPDATE tbl_commandPos
			SET  
				tkh_state=#now()#,
				commandTxt='TEMUJANJINOTES',
				uuidPos='#uuidPos#'
			WHERE telegram_id=#aa.chat.id#
		
		</cfquery>

		<cfset txt="Masukkan Nota :">
		<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt#">
		
		<!--- end update tbl_commandPos--->
	
	<!---TEMUJANJINOTES--->
	<cfelseif commandTxt EQ "TEMUJANJINOTES">

		<cfquery name="Qget" datasource="#dsn#">
			SELECT *
			FROM tbl_appointment
			WHERE uuidPos='#uuidPos#'
		</cfquery>

		
		<!--- save kedalam db masa yang dihantar--->
		<cfquery name="Qupdate" datasource="#dsn#">
			UPDATE tbl_appointment
			SET  
				notes = '#aa.text#'
			WHERE uuidPos='#uuidPos#'
		</cfquery>

		<!--- update tbl_commandPos--->
		<cfquery name="Qupdate" datasource="#dsn#">
				
			UPDATE tbl_commandPos
			SET  
				tkh_state=#now()#,
				commandTxt='TEMUJANJISTATUS',
				uuidPos='#uuidPos#'
			WHERE telegram_id=#aa.chat.id#
		
		</cfquery>

		<cfset txt="Pilih Status :">
		<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt#&reply_markup=#buttonStatus#">
		
		<!--- end update tbl_commandPos--->
	
	<!---TEMUJANJISTATUS--->
	<cfelseif commandTxt EQ "TEMUJANJISTATUS">

		<cfquery name="Qget" datasource="#dsn#">
			SELECT *
			FROM tbl_appointment
			WHERE uuidPos='#uuidPos#'
		</cfquery>

		<!---convert status text kepada int--->
		<cfif #aa.text# is "Confirmed">
			<cfset status =1>
		<cfelseif #aa.text# is "Pending">
			<cfset status =2>
		<cfelseif #aa.text# is "Cancel">
			<cfset status =3>
		</cfif>	
		
		<!--- save kedalam db masa yang dihantar--->
		<cfquery name="Qupdate" datasource="#dsn#">
			UPDATE tbl_appointment
			SET  
				status = #status#,
				entryBy = #aa.chat.id#
			WHERE uuidPos='#uuidPos#'
		</cfquery>

		<!---delete status dlm tbl_commandPos untuk clearkan temp db--->
		<cfquery name="Qdel" datasource="#dsn#">
			DELETE FROM tbl_commandPos
			WHERE telegram_id = '#aa.from.id#'
		</cfquery>

		<cfset txt="Temujanji anda telah disimpan.">
		<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt#&reply_markup=#buttonMenu#">
		
		<!--- end update tbl_commandPos--->
	
	<!---pamer appointment mengikut pilihan user--->
	<cfelseif commandTxt is "PAMER">
		<!---dapatkan user input--->
		<cfset arrTarikh= listToArray(#aa.text#,"-")>
		<!---filter text ambil date--->
		<cfset arrTarikh=listToArray(arrTarikh[1],"/")>
		<cfquery name="Qsearch" datasource="#dsn#">
			SELECT *
			FROM tbl_appointment
			WHERE 	day(Date_App) = #arrTarikh[1]#
				AND month(Date_App) = #arrTarikh[2]#
				AND year(Date_App) = #arrTarikh[3]#
		</cfquery> 

		<cfset txt="">
		<cfloop query="Qsearch">
			<cfset txt="#txt##newline##dateformat(Date_App,'dd mmm yyyy')# #timeformat(masa,'hh:mmtt')#">
			<cfset txt= "#txt##newline##subject##newline##lokasi##newline##notes##newline##status##newline#">
		</cfloop>

		<!---check if data 0--->
		<cfif Qsearch.recordcount EQ 0>
			<cfset txt ="Tiada temujanji pada #aa.text#">
			
		</cfif>
		<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt#&reply_markup=#buttonMenu#">
	
	<!---permohonan--->
	<cfelseif commandTxt EQ "PERMOHONAN">
		
		<cfquery name="Qinsert" datasource="#dsn#">
			insert into tbl_permohonan(
				perkara,
				uuid,
				telegram_pemohon

			) values (
				'#aa.text#',
				'#uuidPos#',
				'#aa.chat.id#'
			)
		</cfquery>
		
		<!--- update tbl_commandPos--->
		<cfquery name="Qupdate" datasource="#dsn#">
				
			UPDATE tbl_commandPos
			SET  
				tkh_state=#now()#,
				commandTxt='PERMOHONANBOS',
				uuidPos='#uuidPos#'
			WHERE telegram_id=#aa.chat.id#
		
		</cfquery>

		<!---list senarai pegawai utk kelulusan--->
		<cfquery name="Qlstbos" datasource="#dsn#">
			SELECT *
			FROM tbl_pegawai
		</cfquery>

		<cfset arrBos="">
		<cfloop query="Qlstbos">
			<cfif arrBos EQ "">
				<cfset arrBos = "[""#nama#""]">
			<cfelse>
				<cfset arrBos = "#arrBos#,[""#nama#""]">
			</cfif>
		</cfloop>

		<cfset buttonBos="{""keyboard"":[#arrBos#,[""/cancel""]],""one_time_keyboard"":true}">
		
		<cfset txt="Sila pilih supervisor #newline##newline#Sys Appointment FRIM">

		<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt#&reply_markup=#buttonBos#" /> 
	
	<!---permohonan bos--->
	<cfelseif commandTxt EQ "PERMOHONANBOS">
		
		<!---get ic pelulus dan telegram id--->
		<cfquery name="QgetPegawai" datasource="#dsn#">
			SELECT *
			FROM tbl_pegawai
			WHERE nama = '#aa.text#'
		</cfquery>

		<cfloop query="QgetPegawai">
			<cfquery name="QgetTelegram" datasource="#dsn#">
				SELECT *
				FROM tbl_daftar
				WHERE noic = '#QgetPegawai.noic#'
			</cfquery>

		</cfloop>
		<cfset telegram_pelulus="#QgetTelegram.telegram_id#">

		<cfquery name="Qinsert" datasource="#dsn#">
			UPDATE tbl_permohonan
			SET
				telegram_pelulus='#telegram_pelulus#'
			WHERE uuid='#uuidPos#'
		</cfquery>
		
		<cfset buttonKelulusan="{""keyboard"":[[""Lulus Permohonan : #newLine##uuidPos#""],[""Tidak Lulus Permohonan : #newline##uuidPos#""],[""Cancel""]],""one_time_keyboard"":true}">

		<cfset txt_pelulus="Mohon kelulusan #newline##newline#Sys Appointment FRIM">
		<cfset txt_pemohon="Permohonan telah dihantar kpd penyelia #newline##newline#Sys Appointment FRIM">

		<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt_pemohon#&reply_markup=#buttonMenu#" />

		<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#telegram_pelulus#&text=#txt_pelulus#&reply_markup=#buttonKelulusan#" /> 

		

	

	</cfif>
	<!---end if commandTxt--->

</cfoutput>
