FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
#COPY *.csproj ./
RUN mkdir -p /usr/local/share/dotnet/sdk/NuGetFallbackFolder
#RUN dotnet restore

# Copy everything else and build
COPY . ./
#RUN dotnet restore --no-cache
RUN dotnet publish -c Release -o out docker-locale-test.csproj

# Build runtime image
#FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
#HEALTHCHECK CMD curl --fail http://127.0.0.1:8083/ || exit 1
# Disable the invariant mode (set in base image)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false DOTNET_ENVIRONMENT=Development TZ=Europe/Berlin LANG=de_DE.UTF-8
# Install cultures (same approach as Alpine SDK image)
#RUN apk add -U --no-cache tzdata icu-libs

ENTRYPOINT ["dotnet", "docker-locale-test.dll"]

# Build the Image
# docker build -t nastymorbol/docker-locale-test .

# Build the Image MultiPlattform
# docker buildx create --name mybuilder --use
# docker buildx inspect --bootstrap
# docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t nastymorbol/docker-locale-test --push .

# Run the Image
# docker run --rm -it -p 8080:80 nastymorbol/docker-locale-test
# docker run -it --network="container:home_fhem_1" nastymorbol/bacnetnf

# Push the Image
# docker push nastymorbol/mydotnet:latest

# rsync -avz --exclude "bin" --exclude "obj" . /Volumes/ftp/dotnet/myapp

# docker-compose
# curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose