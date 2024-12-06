FROM openjdk:17-jdk-alpine
EXPOSE 8089
ADD target/my-app-1.0.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]