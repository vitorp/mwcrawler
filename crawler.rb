require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'terminal-table'
require 'pry'
rows = []
classes = []
_class = {}
site = 'https://matriculaweb.unb.br/graduacao/'
# Lista os campi
# 1 - Darcy Ribeiro
# 2 - Planaltina
# 3 - Ceilândia muita treta
# 4 - Gama
campus_list = [4]
campus_uri = 'oferta_dep.aspx?cod='

# Lista de departamentos (inicialmente vazia)
dep_links = []

# Lista de matérias (inicialmente vazia)
course_links = []

# Itera sobre todos os campi pegando todos os departamentos
campus_list.each do |campus|
  url = site + campus_uri + campus.to_s
  page = Nokogiri::HTML(open(url))
  dep_links = page.css('#datatable tbody tr td:nth-child(3) a').map { |link| link['href'] }
end

# Itera sobre todos os departamentos pegando todas as matérias
dep_links.each do |dep_link|
  url = site + dep_link
  page = Nokogiri::HTML(open(url))
  course_links = page.css('#datatable tr td:nth-child(2) a').map { |link| link['href'] }
end


# Itera sobre todas as matérias pegando todas as turmas
course_links.each do |course_link|
  url = site + course_link
  page = Nokogiri::HTML(open(url))
  page_classes = page.css('.tabela-oferta .turma').map { |item| item.text}
  department 	 = page.css('#datatable tr:first-child a').text
  code 				 = page.css('#datatable')[0].css('tr:nth-child(2) td').text
  course  		 = page.css('#datatable')[0].css('tr:nth-child(3) td').text
  credits 		 = page.css('#datatable')[0].css('tr:nth-child(4) td').text
  

  page_classes.each_with_index do |cl, i|
    row = []
    row << department
    row << code
    row << course
    row << credits
    row << cl
    # HORÁRIOS
    schedules = page.css('.tabela-oferta')[i].css('tr td:nth-child(4) table tr:first-child td').map { |item| item.text }
    schedules.join 
    # PROFESSORES
    teachers = page.css('.tabela-oferta')[i].css('tr td:nth-child(5) td').map { |item| item.text }
    row << teachers.join("\n")
    rows << row  
    puts "Processando"
  end
end
table = Terminal::Table.new :title => "Mal feito, feito", 
    														:headings => ['Departamento', 'Código', 'Nome', 'Créditos', 'Turma', 'Horário', 'Professor'],
    														:rows => rows,
    														:style => {:all_separators => true}

File.open("text.txt", 'w') { |file| file.write(table) }											