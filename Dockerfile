FROM node:10

RUN apt-get update
RUN apt-get install -y libgtk2.0-0 libgconf-2-4 \
    xvfb gconf-service libasound2 libatk1.0-0  libatk-bridge2.0-0 libc6 \
    libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 \
    libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 \
    libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 \
    libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation \
    libappindicator1 libnss3 lsb-release xdg-utils wget

# Remove default fonts
RUN rm -rf /usr/share/fonts/truetype/dejavu/

# Update font cache
COPY fonts /root/.fonts
RUN fc-cache -fv

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN npm config set unsafe-perm true

# Install app dependencies
COPY . /usr/src/app
RUN npm install

RUN npm i pm2 -g

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
CMD ["pm2-runtime", "server.js"]
