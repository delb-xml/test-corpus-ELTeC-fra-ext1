#import git
import glob
import subprocess
import os
import sys

repoRoot='/home/lou/Public/ELTeC-fra-ext'
schemaDir='/home/lou/Public/Schemas/'
inDir=repoRoot+'/level1'

from datetime import date
today = str(date.today())

os.chdir(inDir)
f=open("driver.tei","w")
FILES=sorted(glob.glob('*.xml'))
print(str(len(FILES))+' xml files found in '+inDir)
print("Writing driver file")
f.write('<teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"><teiHeader><fileDesc> <titleStmt> <title>Extended ELTeC-fra repo</title></titleStmt><extent><measure unit="files">'+str(len(FILES))+'</measure></extent> <publicationStmt><p>Unpublished test file</p></publicationStmt><sourceDesc><p>Automatically generated source driver file</p> </sourceDesc> </fileDesc>  <encodingDesc n="eltec-1"><p/></encodingDesc><revisionDesc><change when="'+today+'">driver created</change></revisionDesc></teiHeader>')
for FILE in FILES:
    f.write("<xi:include href='"+FILE+"'/>")
f.write("</teiCorpus>")
f.close()
 
