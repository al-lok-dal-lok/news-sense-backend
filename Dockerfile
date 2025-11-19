# Build stage
FROM gradle:8.5-jdk21 AS build
WORKDIR /app

# Copy gradle files
COPY build.gradle settings.gradle ./
COPY gradlew ./
COPY gradle/ ./gradle/

# Copy source code
COPY src ./src

# Debug: Check if wrapper jar exists
RUN ls -la gradle/wrapper/ && file gradle/wrapper/gradle-wrapper.jar

# Build the application
RUN ./gradlew clean bootJar --no-daemon

# Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Set timezone
ENV TZ=Asia/Seoul

# Run the application
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]
