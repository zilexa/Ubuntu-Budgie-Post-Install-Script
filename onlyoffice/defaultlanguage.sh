#!/bin/bash

cd $HOME/Downloads
wget -O new.docx https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/onlyoffice/new.docx
wget -O new.pptx https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/onlyoffice/new.pptx
wget -O new.xlsx https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/onlyoffice/new.xlsx

echo "============================================================================" 
echo "                                                                            " 
echo "The default document, spreadsheet and presentation have been downloaded.    " 
echo "These are in NL language, if you want to keep this language hit y and Enter " 
echo "                                                                            " 
echo "============================================================================" 
case ${answer:0:1} in
    y|Y )
    sudo mkdir /opt/onlyoffice/converters/nl-NL
    sudo cp new.* /opt/onlyoffice/converters/nl-NL/
    cd /opt/onlyoffice/converters/nl-NL/
    sudo chmod 644 new.docx new.pptx new.xlsx
    sudo chown root:root new.docx new.pptx new.xlsx
    sudo rm /opt/onlyoffice/converters/
    
    TO FINISH LATER 
    
    ;;
    * )
        echo "Not installing all win10/office365 fonts..."
    ;;
esac
