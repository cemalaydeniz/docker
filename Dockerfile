## VOLUME ["/path"]

# Use the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app
# Copy the file containing packages for hot reload, so when a new packe is added, it will take less time to rebuild
COPY *.csproj .
# Restore the packages
RUN dotnet restore
# Copy the projects files
COPY . .
# Publish the app
RUN dotnet publish -c Release -o out

# Build the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
# Copy the published output from the 'build' image
COPY --from=build /app/out ./
# Run the app on the port 3000
ENV ASPNETCORE_URLS="http://*:3000"

ENTRYPOINT ["dotnet", "MyProjectName.dll"]