FROM debian:latest AS build-env

# Install flutter dependencies
RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
RUN cd /usr/local/flutter && git checkout 2.10.2

# Set flutter path
#RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"


#RUN flutter channel stable
# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN pwd
RUN flutter clean
RUN flutter pub get
RUN flutter build web
EXPOSE 5001
# Stage 2 - Create the run-time image
RUN ["chmod", "+x", "/app/server/server.sh"]
ENTRYPOINT [ "/app/server/server.sh"]
#FROM nginx:1.21.1-alpine
#COPY --from=build-env /app/build/web /usr/share/nginx/html
