ARG VERSION=3.1-alpine3.10

FROM mcr.microsoft.com/dotnet/core/sdk:$VERSION AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY src/*.csproj src/
RUN dotnet restore src/SuperService.csproj

# copy and build app
COPY src/ src/
WORKDIR /source/src
RUN dotnet build -c release --no-restore

# test stage -- exposes optional entrypoint
# target entrypoint with: docker build --target test
FROM build AS test
WORKDIR /source/test
COPY test/ .
ENTRYPOINT ["dotnet", "test", "--logger:trx"]

FROM build AS publish
RUN dotnet publish \
    -c release \
    -o /app \
    --no-build \
    --no-restore 
    
# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:$VERSION as base

# The user the app should run as
ENV APP_USER=app

# The home directory
ENV APP_DIR="/$APP_USER"

RUN adduser \
  --disabled-password \
  --home $APP_DIR \
  --gecos '' $APP_USER \
  && chown -R $APP_USER $APP_DIR

USER $APP_USER

# default directory is /app
WORKDIR $APP_DIR

# copy application over
COPY --from=publish $APP_DIR ./
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 \
    ASPNETCORE_URLS=http://+:8080

# run app as non root user
EXPOSE 8080
ENTRYPOINT ["dotnet", "SuperService.dll"]
