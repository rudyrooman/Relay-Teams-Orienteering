
from bs4 import BeautifulSoup
import webbrowser
import urllib
import urllib2
import xlsxwriter
import numpy

# lijst inlezen
loperslijst = {}
with open("lijstsnelheid.txt") as f:
    for line in f:
       (runner, name) = line.split('\t')
       loperslijst[runner] = str(name.rstrip('\n'))

# onderstaande commentaar wegdoen om 1 record te testen
#loperslijst = {'1594':'Ralph Kurt'}

# resultaatlijst initialiseren
resultaatslijst= {}
standarddevlijst ={}
lopersoutputlijst= {}

# opzoeken loper en berekenen gemiddelde snelheid
for k in loperslijst:
    loper = k
    url = 'http://helga-o.com/webres/showrunner.php?runner='+loper
    # inlezen website helga
    soup = BeautifulSoup(urllib2.urlopen(url).read(), 'html.parser')
    alletext= soup.get_text()
    # opzoeken en corrigeren aantal gefiniste wedstrijden gelopen laatste jaar
    aantalwed= int(alletext[alletext.find('(')+1:alletext.find(')')])
    positie =1
    teller = aantalwed
    while positie>0:
        positie= alletext.find('NCL',positie+5)
        teller= teller-1
    teller=teller+1
    positie =1
    while positie>0:
        positie= alletext.find('DSQ',positie+5)
        teller= teller-1
    teller=teller+1
    # initialisatie
    ftr = [60,1]
    positie= 10
    lijst = []
    for aa in range(1,teller):
        positie= alletext.find('''"''',positie)
         
        if alletext[positie+1:positie+7]=='Emblem' :
            positie= alletext.find('''"''',positie+9)
        timestr= alletext[alletext.find(''':''',positie-8,positie)+3:alletext.find('''"''',positie)]
        #print timestr
        snelheidinsec= sum([a*b for a,b in zip(ftr, map(int,timestr.split("""'""")))])
        lijst.append(snelheidinsec)
        positie = alletext.find('''"''',positie)+2 
    lijst.sort()
    # berekenen van gemiddelde snelheid in sec
    average= round(numpy.mean(lijst))
    # berekenen van standard dev in sec
    standarddev= round(numpy.std(lijst))
    # verwijderen van waarden > average + 2 standdard dev 
    while lijst[len(lijst)-1]> average+ 2* standarddev :
        lijst.pop()
    # verwijderen van waarden < average - 2 standdard dev 
    lijst.reverse()
    while lijst[len(lijst)-1]< average- 2* standarddev :
        lijst.pop()   
    print ' We houden rekening met '+str(len(lijst))+' beste resultaten van '+str(aantalwed) +' wedstrijden.('+ str(aantalwed-teller)+ ' NCL)'
    # berekenen van gemiddelde snelheid in sec na opkuisen lijst
    average= round(numpy.mean(lijst))
    #print average
    # berekenen van standard dev in sec na opkuisen lijst
    standarddev= round(numpy.std(lijst))
    #print standarddev
    print ' De gemiddelde snelheid van '+loperslijst[loper] + '= '+str(int(average/60))+ """'""" +str(int(average-60*int(average/60))) +'''"'''
    resultaatslijst[loper]= round(float(average)/60,2)
    print 
    standarddevlijst[loper]= round(float(standarddev)/60,2)
    lopersoutputlijst[loper]= str(loperslijst[loper])

# Create a workbook and add a worksheet to save results
workbook = xlsxwriter.Workbook('Output.xlsx')
worksheet = workbook.add_worksheet()
# Start from the first cell. Rows and columns are zero indexed.
row = 0
col = 0
# Write headers
worksheet.write(row, col, 'Helga-nummer')
worksheet.write(row, col+1, 'Gemiddelde snelheid')
worksheet.write(row, col+2, 'Standaard dev.')
worksheet.write(row, col+3, 'Naam')

row=1
# Iterate over the data and write it out row by row.
for item  in resultaatslijst:
    worksheet.write(row, col, int(item))
    worksheet.write(row, col + 1, resultaatslijst[item])
    row += 1

row = 1
for item  in standarddevlijst:
    worksheet.write(row, col + 2, standarddevlijst[item])
    row += 1
    
row = 1
for item in lopersoutputlijst:
    worksheet.write_string(row, col + 3, lopersoutputlijst[item])
    row += 1

workbook.close()





