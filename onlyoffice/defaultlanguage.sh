#!/bin/bash

cd /opt/onlyoffice/desktopeditors/converter/empty/
sudo mkdir nl-NL
sudo wget -O nl-NL/new.docx https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/onlyoffice/new.docx
sudo wget -O nl-NL/new.pptx https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/onlyoffice/new.pptx
sudo wget -O nl-NL/new.xlsx https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/onlyoffice/new.xlsx

echo "==========================================================================================" 
echo "                                                                                          " 
echo "OnlyOffice default document language & spellcheck is US English.                          "
echo "To change it to your language, you need to adjust the default template.                   "
echo "OnlyOffice has no way of doing this normally and permissions prevent you to do this easily" 
echo "                                                                                          "
echo "To use Dutch (NL) hit 'y' and 'ENTER.'                                                    " 
echo "                                                                                          "
echo "To use a different language, hit "n" and "ENTER" and follow the instructions.             "
echo "                                                                                          " 
echo "==========================================================================================" 
case ${answer:0:1} in
    y|Y )
    echo "Replace the template files to support nl-NL default document language.." 
    # Copy the templates to the converter/empty dir
    sudo cp nl-NL/new.* ./
    # Remove the templates with prefix in_ and _mm as we need to replace them
    sudo rm in_*
    sudo rm mm_*
    # Copy the new.* templates and rename the copies by adding in_ prefix
    for f in new.*; do sudo cp -- "$f" "in_$f"; done
    # Rename the new.* templates, add mm_ 
    for f in new.*; do sudo mv -- "$f" "mm_$f"; done
    echo "done!" 
    ;;
    * )
        sudo xdg-open nl-NL/
        echo "Follow the instructions in that link". 
    ;;
esac
