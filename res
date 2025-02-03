plugins {
    id 'java'
    id 'org.springframework.boot' version '3.3.7'
    id 'io.spring.dependency-management' version '1.1.5'
    id 'no.nils.wsdl2java' version '0.12' // Updated plugin
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

wsdl2java {
    // New configuration format for Gradle 9
    wsdlsToGenerate = [
        ['-autoNameResolution', '-B-Xequals', '-B-XhashCode', 
         "$projectDir/src/main/resources/wsdl/your-service.wsdl".toString()]
    ]
    generatedWsdlDir = file("${project.buildDir}/generated-sources/jaxb")
    wsdlDir = file("$projectDir/src/main/resources/wsdl")
    cxfVersion = "4.0.3" // CXF version compatible with javax
}

sourceSets {
    main {
        java {
            srcDirs += ["${project.buildDir}/generated-sources/jaxb"]
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

// Ensure generation before compilation
tasks.named('compileJava') {
    dependsOn wsdl2java
}
