# encoding: utf-8
require './database'
require './location'
require 'roo'

class Import

	def initialize
		
		file = Roo::Spreadsheet.open('/source/importing_xls_and_convert_coordinates/import2.xlsx')
		
		file = Roo::Excelx.new("/source/importing_xls_and_convert_coordinates/import2.xlsx")

		#xls
		#file = Roo::Spreadsheet.open('source/import_xls/import2.xls', extension: :xls)
		Location.import(file)
		
	end 

end

Import.new