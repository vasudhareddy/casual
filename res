plugins {
    id 'java'
    id 'org.springframework.boot' version '3.3.7'
    id 'io.spring.dependency-management' version '1.1.5'
    id 'com.github.sherter.google-java-format' version '0.9' // Optional formatting
    id 'org.apache.cxf.buildutils.cxf-codegen-plugin' version '4.0.3' // Official CXF plugin
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

// Configure CXF WSDL-to-Java generation
cxf {
    wsdl2java {
        projectDir = file("$projectDir")
        outputDir = file("${project.buildDir}/generated/sources/wsdl2java")
        wsdl = file("src/main/resources/wsdl/your-service.wsdl")
        extraArgs = [
            '-autoNameResolution',
            '-B-Xequals',
            '-B-XhashCode',
            '-fe', 'jaxws21', // Force JAX-WS 2.1 (javax.*)
            '-b', 'src/main/resources/jaxb/bindings.xml' // Optional bindings
        ]
    }
}

// Add generated sources to compilation path
sourceSets {
    main {
        java {
            srcDirs += ["${project.buildDir}/generated/sources/wsdl2java"]
        }
    }
}

dependencies {
    // Spring Boot
    implementation 'org.springframework.boot:spring-boot-starter-web'
    
    // JAXB (javax) dependencies
    implementation 'javax.xml.bind:jaxb-api:2.3.1'
    implementation 'com.sun.xml.bind:jaxb-core:2.3.0.1'
    implementation 'com.sun.xml.bind:jaxb-impl:2.3.6'
    
    // CXF dependencies
    implementation 'org.apache.cxf:cxf-rt-frontend-jaxws:4.0.3'
    implementation 'org.apache.cxf:cxf-rt-transports-http:4.0.3'
    
    // Java 17 annotations
    implementation 'javax.annotation:javax.annotation-api:1.3.2'
    
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

tasks.named('test') {
    useJUnitPlatform()
}

// Ensure code generation happens before compilation
compileJava.dependsOn cxfWsdl2java
