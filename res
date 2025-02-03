plugins {
    id 'java'
    id 'org.springframework.boot' version '3.3.7'
    id 'io.spring.dependency-management' version '1.1.5'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

configurations {
    cxf
}

dependencies {
    // Spring Boot
    implementation 'org.springframework.boot:spring-boot-starter-web'
    
    // CXF Dependencies (using last javax-compatible version)
    implementation 'org.apache.cxf:cxf-codegen-plugin:3.5.5'
    implementation 'org.apache.cxf:cxf-rt-frontend-jaxws:3.5.5'
    
    // JAXB (javax) dependencies
    implementation 'javax.xml.bind:jaxb-api:2.3.1'
    implementation 'com.sun.xml.bind:jaxb-core:2.3.0.1'
    implementation 'com.sun.xml.bind:jaxb-impl:2.3.6'
    
    // CXF Tools for WSDL generation
    cxf 'org.apache.cxf:cxf-tools-wsdlto-core:3.5.5'
    cxf 'org.apache.cxf:cxf-tools-wsdlto-frontend-jaxws:3.5.5'
    cxf 'org.apache.cxf:cxf-tools-wsdlto-databinding-jaxb:3.5.5'
    
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

// Custom task for WSDL-to-Java generation
task wsdl2java(type: JavaExec) {
    classpath = configurations.cxf
    mainClass = 'org.apache.cxf.tools.wsdlto.WSDLToJava'
    
    args '-d', "${project.buildDir}/generated/sources/wsdl2java",
         '-fe', 'jaxws21',  // Force javax namespace
         '-autoNameResolution',
         '-B-Xequals',
         '-B-XhashCode',
         '-client',
         "${projectDir}/src/main/resources/wsdl/your-service.wsdl"
         
    doFirst {
        logger.lifecycle("Generating Java classes from WSDL...")
        file("${project.buildDir}/generated/sources/wsdl2java").mkdirs()
    }
}

// Add generated sources to compilation
sourceSets {
    main {
        java {
            srcDirs += ["${project.buildDir}/generated/sources/wsdl2java"]
        }
    }
}

// Ensure generation happens before compilation
compileJava.dependsOn wsdl2java

tasks.named('test') {
    useJUnitPlatform()
}
