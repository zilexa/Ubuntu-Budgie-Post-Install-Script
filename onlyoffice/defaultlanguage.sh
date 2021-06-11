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
    
    sudo cp nl-NL/new.*
    
    sudo chmod 644 new.docx new.pptx new.xlsx
    sudo chown root:root new.docx new.pptx new.xlsx
    sudo rm /opt/onlyoffice/converters/
    
    TO FINISH LATER 
    
    ;;
    * )
        echo "Not installing all win10/office365 fonts..."
    ;;
esac
