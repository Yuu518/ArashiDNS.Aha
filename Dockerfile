#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
ARG TARGETARCH
COPY . /src
WORKDIR /src
RUN dotnet publish -a $TARGETARCH -c Release -o /app /p:UseAppHost=true /p:PublishAot=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS disk
WORKDIR /app
COPY --from=build /app .
ENV ARASHI_ANY=1
ENV ARASHI_RUNNING_IN_CONTAINER=1
EXPOSE 16883
ENTRYPOINT ["dotnet", "ArashiDNS.Aha.dll"]