configurations.all {
    resolutionStrategy {
        eachDependency { DependencyResolveDetails details ->
            if (details.requested.group == 'org.glassfish.jaxb') {
                details.useVersion '2.3.6'
            }
            if (details.requested.group == 'jakarta.xml.bind') {
                details.useVersion '2.3.3'
            }
        }
    }
}
