FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# Create FallBackOrder if not extsts
RUN mkdir -p /usr/local/share/dotnet/sdk/NuGetFallbackFolder

# Copy everything and build
COPY . ./
RUN dotnet publish -c Release -o out docker-locale-test.csproj

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false DOTNET_ENVIRONMENT=Development TZ=Europe/Berlin LANG=de_DE.UTF-8

ENTRYPOINT ["dotnet", "docker-locale-test.dll"]

