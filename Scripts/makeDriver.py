#import git
import glob
import subprocess
import os
import sys

repoRoot='/home/lou/Public/romandixneuf'
schemaDir='/home/lou/Public/Schemas/'
inDir=repoRoot+'/master/'
outDir=repoRoot+'/eltec/'
cligsConv=repoRoot+'/Scripts/cligstoeltec.xsl'

from datetime import date
today = str(date.today())

os.chdir(outDir)
f=open("driver.tei","w")
FILES=sorted(glob.glob('*.xml'))
print(str(len(FILES))+' files found in '+outDir)
print("Writing driver file")
f.write('<teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"><teiHeader><fileDesc> <titleStmt> <title>Roman 19 repo</title></titleStmt><extent><measure unit="files">'+str(len(FILES))+'</measure></extent> <publicationStmt><p>Unpublished test file</p></publicationStmt><sourceDesc><p>Automatically generated source driver file</p> </sourceDesc> </fileDesc>  <encodingDesc n="eltec-1"><p/></encodingDesc><revisionDesc><change when="'+today+'">driver created</change></revisionDesc></teiHeader>')
for FILE in FILES:
    f.write("<xi:include href='"+FILE+"'/>")
f.write("</teiCorpus>")
f.close()
 
