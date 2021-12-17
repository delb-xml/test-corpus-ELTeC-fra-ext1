
import glob
import subprocess
import os
import sys

repoRoot='/home/lou/Public/ELTeC-fra-ext/'
schemaDir='/home/lou/Public/Schemas/'
inDir=repoRoot+'/home/lou/Public/romandixneuf/master/'
outDir=repoRoot+'/R19/'
cligsConv=repoRoot+'/Scripts/cligstoeltec.xsl'

print("Converting from "+inDir+' to '+outDir)
os.chdir(inDir)
FILES=sorted(glob.glob('*.xml'))
for FILE in FILES:
    command="saxon "+FILE+" "+cligsConv+" > "+outDir+FILE
    print(command)
    subprocess.check_output(command,shell=True)
    command="jing "+schemaDir+"eltec-1.rng "+outDir+FILE
    print(command)
    subprocess.check_output(command,shell=True)
    
