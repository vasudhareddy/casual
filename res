plugins {
    id 'java'
    id 'org.springframework.boot' version '3.3.7'
    id 'io.spring.dependency-management' version '1.1.5'
    id 'com.github.bjornvester.wsdl2java' version '2.1.0'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

// Configure JAXB generation
wsdl2java {
    generatedSourcesDir = file("${project.buildDir}/generated-sources/jaxb")
    wsdlDir = file("${project.projectDir}/src/main/resources/wsdl")
    wsdlsToGenerate = [
        ['-XautoNameResolution', '-B-Xequals', '-B-XhashCode', "${project.projectDir}/src/main/resources/wsdl/your-service.wsdl"]
    ]
}

// Add generated sources to main source set
sourceSets {
    main {
        java {
            srcDirs += ["${project.buildDir}/generated-sources/jaxb"]
        }
    }
}

dependencies {
    // Spring Boot Starter
    implementation 'org.springframework.boot:spring-boot-starter-web'

    // JAXB dependencies (javax.xml.bind)
    implementation 'javax.xml.bind:jaxb-api:2.3.1'
    implementation 'com.sun.xml.bind:jaxb-core:2.3.0.1'
    implementation 'com.sun.xml.bind:jaxb-impl:2.3.6'

    // JAX-WS dependencies
    implementation 'com.sun.xml.ws:jaxws-rt:4.0.1'
    implementation 'com.sun.xml.ws:rt:4.0.1'

    // Required for Java 17 compatibility
    implementation 'javax.annotation:javax.annotation-api:1.3.2'
    implementation 'javax.jws:javax.jws-api:1.1'

    // Test dependencies
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

tasks.named('test') {
    useJUnitPlatform()
}

// Ensure code generation happens before compilation
tasks.named('compileJava') {
    dependsOn wsdl2java
}
