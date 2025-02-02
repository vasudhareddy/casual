plugins {
    id 'java'
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'javax.xml.bind:jaxb-api:2.3.1' // JAXB API
    implementation 'org.glassfish.jaxb:jaxb-runtime:2.3.5' // JAXB Runtime (implementation)
    implementation 'org.apache.cxf:cxf-tools-wsdlto-core:3.5.6' // CXF tools
    implementation 'org.apache.cxf:cxf-tools-wsdlto-databinding-jaxb:3.5.6'
    implementation 'org.apache.cxf:cxf-tools-wsdlto-frontend-jaxws:3.5.6'
}

task generateWsdl2Java(type: JavaExec) {
    group = 'build'
    description = 'Generates Java classes from WSDL'
    
    main = 'org.apache.cxf.tools.wsdlto.WSDLToJava'  // CXF WSDL to Java tool
    classpath = configurations.compileClasspath
    
    args = [
        '-d', "$buildDir/generated-sources",    // Output directory for generated files
        '-p', 'com.example.generated',         // Package name for generated classes
        '-wsdlLocation', 'src/main/resources/wsdl/YourService.wsdl' // Path to your WSDL
    ]
}

compileJava.dependsOn generateWsdl2Java // Ensure the task runs before Java compilation
