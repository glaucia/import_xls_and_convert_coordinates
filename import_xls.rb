# encoding: utf-8
require './database'
require './location'
require 'roo'
require 'roo-xls'

class Import

	def initialize
		
		file = Roo::Spreadsheet.open('/home/glaucia/glauciahm/source/importing_xls_and_convert_coordinates/import2.xlsx')
		
		file = Roo::Excelx.new("/home/glaucia/glauciahm/source/importing_xls_and_convert_coordinates/import2.xlsx")

		#xls
		#file = Roo::Spreadsheet.open('/home/glaucia/glauciahm/source/import_xls/import2.xls', extension: :xls)
		Location.import(file)
		puts("RETORNOU")
	end 

end

Import.new