FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY ["Take.API.Authorization/Take.API.Authorization.csproj", "Take.API.Authorization/"]
RUN dotnet restore "Take.API.Authorization/Take.API.Authorization.csproj"
COPY . .
WORKDIR "/src/Take.API.Authorization"
RUN dotnet build "Take.API.Authorization.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Take.API.Authorization.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "Take.API.Authorization.dll"]
CMD ASPNETCORE_URLS=http://*:$PORT Take.API.Authorization.dll
