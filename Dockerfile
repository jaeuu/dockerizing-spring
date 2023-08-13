# Build Stage
FROM openjdk:16 AS build
LABEL maintainer="email"
WORKDIR /app
COPY . .
RUN gradle build continue > /dev/null 2>&1 || true

# Final Stage
FROM openjdk:16-jdk
LABEL maintainer="email"
ARG JAR_FILE=/app/build/libs/*.jar
COPY --from=build ${JAR_FILE} /docker-springboot.jar
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-Dspring.profiles.active=develop", "-jar", "/docker-springboot.jar"]
EXPOSE 8080