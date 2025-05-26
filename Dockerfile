# trusty = 14.04
FROM ubuntu:trusty

# v43 = 320008
# v36 = 286061
ARG CHROME_REVISION=286061

RUN apt-get update; apt-get clean

# Add a user for running applications.
RUN useradd apps
RUN mkdir -p /home/apps && chown apps:apps /home/apps

# Install x11vnc.
RUN apt-get install -y x11vnc

# Install xvfb.
RUN apt-get install -y xvfb

# Install fluxbox.
RUN apt-get install -y fluxbox

# Install wget.
RUN apt-get install -y wget

# Install wmctrl.
RUN apt-get install -y --no-install-recommends wmctrl
RUN apt-get install -y --no-install-recommends curl

# Set the Chrome repo.
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
# RUN curl --http1.1 -L https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#     && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get install -y libnss3
RUN apt-get install -y --no-install-recommends libatk1.0-0
RUN apt-get install -y --no-install-recommends libgbm1

RUN curl --http1.1 -L -o chrome.zip "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$CHROME_REVISION%2Fchrome-linux.zip?generation=1426035118231000&alt=media"
RUN apt-get install -y unzip
RUN unzip chrome.zip

RUN mkdir -p chrome-deb/opt/google/chrome
RUN cp -r /chrome-linux/* chrome-deb/opt/google/chrome/
RUN mkdir -p chrome-deb/usr/share/applications
RUN mkdir -p chrome-deb/DEBIAN
RUN mkdir -p chrome-deb/usr/share/applications && \
    echo '[Desktop Entry]' > chrome-deb/usr/share/applications/google-chrome.desktop && \
    echo 'Version=1.0' >> chrome-deb/usr/share/applications/google-chrome.desktop && \
    echo 'Name=Google Chrome' >> chrome-deb/usr/share/applications/google-chrome.desktop && \
    echo 'Exec=/opt/google/chrome/chrome --no-sandbox' >> chrome-deb/usr/share/applications/google-chrome.desktop && \
    echo 'Icon=google-chrome' >> chrome-deb/usr/share/applications/google-chrome.desktop && \
    echo 'Type=Application' >> chrome-deb/usr/share/applications/google-chrome.desktop && \
    echo 'Categories=Network;WebBrowser;' >> chrome-deb/usr/share/applications/google-chrome.desktop

RUN echo 'Package: google-chrome' > chrome-deb/DEBIAN/control && \
    echo 'Version: 1.0' >> chrome-deb/DEBIAN/control && \
    echo 'Architecture: amd64' >> chrome-deb/DEBIAN/control && \
    echo 'Maintainer: BananaMan' >> chrome-deb/DEBIAN/control && \
    echo 'Description: Google Chrome manually packaged' >> chrome-deb/DEBIAN/control

RUN dpkg-deb --build chrome-deb
RUN dpkg -i chrome-deb.deb

# Install Chrome.
# RUN apt-get update && apt-get -y install google-chrome-stable

COPY bootstrap.sh /
RUN chmod +x /bootstrap.sh

RUN echo 'root:pass' | chpasswd
RUN apt-get install -y --no-install-recommends libgconf-2-4
RUN apt-get install -y libpango1.0-0
RUN apt-get install -y libxcursor1
RUN apt-get install -y libasound2
RUN apt-get install -y libcups2
RUN apt-get install -y libgtk2.0-0
RUN apt-get install -y locales

CMD '/bootstrap.sh'
