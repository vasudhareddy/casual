dependencies {
    implementation 'javax.xml.bind:jaxb-api:2.3.1'
    implementation 'com.sun.xml.bind:jaxb-core:2.3.1'
    implementation 'com.sun.xml.bind:jaxb-impl:2.3.1'

    configurations.all {
        resolutionStrategy {
            eachDependency { details ->
                if (details.requested.group == 'com.sun.xml.bind' && details.requested.name == 'jaxb-core') {
                    details.useVersion '2.3.1'
                }
            }
        }
    }
}
