# Syncthing
echo "======================================="
echo "---------------------------------------"
echo "Install Syncthing (Y/n)?"
read -p "Syncthing is a fast and lightweight tool for 2-way syncing between your devices." answer
case ${answer:0:1} in
    y|Y )
       # Add syncthing repository
       curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
       echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
       printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | sudo tee /etc/apt/preferences.d/syncthing
       # Create the dir containing sycnthing db, this will make sure the db will be stored here, seperately from syncthing config. Highly recommended. 
       mkdir $HOME/.local/share/syncthing
       # Install Syncthing
       sudo apt -y install syncthing
       sudo wget -O /etc/systemd/system/syncthing@.service https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/syncthing/syncthing%40.service
       # Enable the systemd service with a generic name, this way we can ensure to create a system service that starts even when not logged in. 
       sudo systemctl enable syncthing@.service
       # systemctl does not allow environment variables, manually create service link with system username
       sudo ln -s /etc/systemd/system/syncthing@.service /etc/systemd/system/multi-user.target.wants/syncthing@${USER}.service
    ;;
    * )
        echo "Not enabling Syncthing..."
    ;;
esac




This looks cool
https://askubuntu.com/questions/892916/change-folder-icon-of-multiple-folders-movies
