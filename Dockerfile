# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-21-alpine AS baseImage
WORKDIR /app
COPY . .
RUN mvn clean install -DskipTests

# Stage 2: Run on Tomcat
FROM tomcat:10.1.46-jdk21-temurin-jammy
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=baseImage /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
