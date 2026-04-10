# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY ["DotNetApp.csproj", "./"]
RUN dotnet restore "DotNetApp.csproj"

# Copy everything else and build
COPY . .
RUN dotnet build "DotNetApp.csproj" -c Release -o /app/build

# Publish
FROM build AS publish
RUN dotnet publish "DotNetApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 80
EXPOSE 443
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetApp.dll"]
