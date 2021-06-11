# ONLYOFFICE DESKTOPEDITORS
## How to change the language/spellchecker for newly created documents?
When you create a new document, spreadsheet or presentation with OnlyOffice, the default language is always en-US, cs-CZ, es-ES, fr-FR, it-IT, pt-BR or ru-RU depending on your system language.

#### The problem:
OnlyOffice has support for many more languages! But it is not possible to change the default language in the program.

#### The solution
To do this anyway, either use the script to change to nl-NL or follow the below instrcutions to change to any other language supported by OnlyOffice:

#### Instructions
Goal: 
create a folder with your language containing template files with your language in: 
/opt/onlyoffice/desktopeditors/converter/empty/ contains folders for each language. You want to add a folder for your language, containing template files.
/opt/onlyoffice/desktopeditors/converter/empty also contains 2 sets of files: `in_new.docx` and `mm_new.docx`, also for pptx and xlsx. You want to replace them with your template files.

Constraints:
1. It is somehow not possible to modify these files: you cannot save them even with root/permissions, probably because this is the installation program folder of OnlyOffie.
2. All files need to be owned by root and with 644 permissions. 

To reach our goal and overcome the constraints, do the following. Note this is written so that any noob can do this:


1. To create your own language template, simply copy an existing default template folder to a location where you can edit it. For example, the folder cs-CZ exists, let's use that:
```
cp /opt/onlyoffice/desktopeditors/converter/empty/cs-CZ $HOME/Downloads
```
2. Set permissions so that you can edit the files:
```
sudo chown -R ${USER}:${USER} $HOME/Downloads/cs-CZ
sudo chmod -R 777 $HOME/Downloads/cs-CZ
```
3. Change the language!
- In your Downloads/cs-CZ folder, open new.docx and new.pptx in OnlyOffice and for each click the globe at bottom and select desired language.
- Also open new.xslx, go to File > Advanced Settings and change language for General AND for Page Settings. 
Save each file! 

4. Now find out your language code, see a list here: http://www.lingoes.net/en/translator/langcode.htm

5. In Downloads, rename the folder cs-CZ to your language code, for example if you want Danish: rename the folder from cs-CZ to da-DK.

6. Finally, go back to your Terminal and use the commands below to move that folder back to the Onlyoffice folder and set correct ownership/permissions.
```
sudo chown -R root:root $HOME/Downloads/da-DK
sudo chmod -R 644 $HOME/Downloads/da-DK
sudo mv $Downloads/da-DK /opt/onlyoffice/desktopeditors/converter/empty/
```

7. And now copy those files, 1 folder higher, so that they also appear in /empty:
```
cd /opt/onlyoffice/desktopeditors/converter/empty/
sudo sudo cp da-DK/new.* ./
```
You should now have 3 files called `new`, besides the 6 files `in_new` and `mm_new`. 

8. In /empty,replace the exisitng 'in_new' and 'mm_new' files with yours by removing the old ones and copying/renaming your versions.
```
cd 
# Remove the templates with prefix in_ and _mm as we need to replace them
sudo rm in_*
sudo rm mm_*
# Copy the new.* templates and rename the copies by adding in_ prefix
for f in new.*; do sudo cp -- "$f" "in_$f"; done
# Rename the new.* templates, add mm_ 
for f in new.*; do sudo mv -- "$f" "mm_$f"; done
```

That's it!
