# Converting CLIGS to ELTEC

The XSLT stylesheet `cligstoeltec.xsl` in this folder can be used to convert files in CLIGS format to something which is valid against the eltec-1 schema. The stylesheet needs access to an XML file containing metadata (`metadata.xml`) to find dates and a few other details.

The workflow is as follows:
 - convert the CLIGS  `metadata.csv` file to `metadata.xml` (using  standard `csvtotei` command)
 - convert each xml file in the CLIGS source folder `~/Public/romandixneuf/master` (this is my local copy downloaded from `https://github.com/cligs/romandixneuf`) to a file of the same name in the folder `R19` There are lots of ways of doing this, but the quickest for me is with the following command lines:
~~~~
 cd ~/Public/ELTeC-fra-ext
 saxon -s:../romandixneuf/master -o:R19 Scripts/cligstoeltec.xsl`
~~~~
- validate each resulting file against the schema `eltec-1.rng` (also quite a few ways: my preferred method is to make a driver file (which can then be tweaked to suppress invalid files temporarily) like that in `R19/fulldriver.tei`  (the script `makeDriver.py` generates this file, which can be validated against the ELTeC schema `eltec-repo.rng` (the TEI corpus header this generates doesn't have a profileDesc which the validation then complains about but I just ignore it)

Alternatively, the python script `cligsConv.py` will step through the source directory, correcting and then validating it, one file at a time. But this will stop as soon as it finds an invalid file and I haven't the python skills to make it soldier on. 

I stopped tweaking my stylesheet when the number of systematic errors dropped below 30 or so.  At that point, only 27 files (listed in `errorFiles.txt`) were being reported as invalid. This doesn't mean that the other 340 or so are all correct of course. 

In particular, I did not carry out any schematron validation at this stage, so div/@type values are very haphazard, and notes are all over the place.

The easiest way to see all the errors in all the files is to add lines
~~~~
<?xml-model href="../../Schemas/eltec-repo.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="../../Schemas/eltec-repo.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
~~~~
to the top of the file `fullDriver.tei`, assuming your copies of the eltec schemas are in the same place as mine. Opening this modified file in oXygen will then report everything.

