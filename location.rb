# encoding: utf-8
class Location < ActiveRecord::Base

	def self.import(spreadsheet)

	    if spreadsheet
		    header = spreadsheet.row(1)
		    duplicate_codes = []
		    check = true

		    (2..spreadsheet.last_row).each do |i|
		    	row = spreadsheet.row(i)		  
		        if row[0] != nil
		      		lc = Location.find_by_location_code(row[0])
		           	if lc  #=> se existir location_code no bd o check é falso, pois lc deve ser único
						check = false
			        	duplicate_codes << row[0]
			        end
			        if row[1] == nil or row[2] == or row[3] == nil  #=> se o campo location_code estiver vazio o check é falso
			            check = false
			        end
		        end
			end			

		    if duplicate_codes.uniq.length == duplicate_codes.length #if duplicate_codes.size > 0
		    	location_code 		= true
		    else
	      		location_code 		= false
	    	end
	
	    	if check == true and location_code == true
	    		(2..spreadsheet.last_row).each do |i|
		        	row = spreadsheet.row(i)
		        	verify_coordinate_format(row[2], row[3])
		        	#verify_coordinate_format(row)
		        	save_locations_from_xls(row)
	      		end

	    	end
	  	

	  	else
	   		return
	  	end
	end



 	def verify_coordinate_format(latitude, longitude)
 	 	logger.info("====== ROW FROM XLS ============ #{row}")
 	 	#latitude  = row[2].strip
		#longitude = row[3].strip

		if latitude.last == "S"
			la  = latitude.split("°")
			lat = "-#{la[0]}"
		elsif latitude.last == "N"
			la  = latitude.split("°")
			lat = "#{la[0]}"
		else
			lat = latitude
		end

			logger.info("====== LATITUDE CONVERTED  ===== #{lat}")

	  	if longitude.last == "W"
	  		lo = longitude.split("°")
	  		lng = "-#{lo[0]}"
	  	elsif longitude.last == "E"
	  		lo = longitude.split("°")
	  		lng = "#{lo[0]}"
	  	else
	  		lng = longitude
	  	end
	  	  	logger.info("====== LONGITUDE CONVERTED ===== #{lng}")

	  	#converter do formato google (DD) para o formato do banco de dados (DMS)
	  	convert_ddToDms(lat, lng) 
	end


  	def convert_ddToDms(latitude, longitude) 
	    latitude_to_s = latitude.to_s

	    heading = latitude_to_s[0]
	    ########### HEADING AND DEGREES ###########
	    #@lat_heading = (lat >= 0)? 'N' : 'S';
	    if heading == "-"
	      @lat_heading = "S"
	      @lat_degrees = latitude_to_s[1..2]
	    else  
	      @lat_heading = "N"
	      @lat_degrees = latitude_to_s[0..1]
	    end
		
	    ########### LATITUDE MINUTES ##############
	    latitude_parse  	  = latitude.split(".")
	    latitude_to_f   	  = "0.#{latitude_parse[1]}".to_f
	    calc_latitude_minutes = (latitude_to_f*60).to_s
	    #Guarda o valor da latitude com 4 digitos depois da virgula
	    @lat_minutes    	  = calc_latitude_minutes[0..6]

	    longitude_to_s = longitude.to_s
	    heading = longitude_to_s[0]

	    ########### HEADING AND DEGREES ###########
	    if heading == "-"
	      @lng_heading  = "W"
	      @lng_degrees  = longitude_to_s[1..2]
	    else  
	      @lng_heading  = "E"
	      @lng_degrees  = longitude_to_s[0..1]
	    end

	    ########### LATITUDE MINUTES #############
	    longitude_parse  = longitude.split(".")
	    longitude_to_f   = "0.#{longitude_parse[1]}".to_f
	    calc_longitude_minutes  = (longitude_to_f*60).to_s
	    #Guarda o valor da latitude com 4 dígitos depois da virgula
	    @lng_minutes     = calc_longitude_minutes[0..6]


  	end
  	
   	def save_locations_from_xls(row)
	  	#[101.0, "Ponto Interlagos inicio", "-23.659392901940656", "-46.68911786376111"] OR
	  	#[201601.0, "Ferreira (Inicio) – ida", "25.518710°S", "54.563739°W"]

		############################## SALVAR NO BD ###################################### 
	  	location = Location.new

	    location.location_code      = row[0].strip.to_i
	    location.description        = row[1]
	    location.latitude_degrees   = @lat_degrees
	    location.latitude_minutes   = @lat_minutes
	    location.latitude_heading   = @lat_heading    
	    location.longitude_degrees  = @lng_degrees
	    location.longitude_minutes  = @lng_minutes
	    location.longitude_heading  = @lng_heading
	    location.district_id	 	=	1
	    location.save!
	  
  	end  


	Location.new
end