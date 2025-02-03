import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

@Component
public class JaxbConfig {

    @Bean
    public Marshaller marshaller() throws JAXBException {
        // Create JAXBContext for the required class (replace YourClass.class with your JAXB-generated class)
        JAXBContext context = JAXBContext.newInstance(YourClass.class);

        // Create the Marshaller (for converting Java objects to XML)
        Marshaller marshaller = context.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);  // Optional: pretty print the XML
        return marshaller;
    }

    @Bean
    public Unmarshaller unmarshaller() throws JAXBException {
        // Create JAXBContext for the required class (replace YourClass.class with your JAXB-generated class)
        JAXBContext context = JAXBContext.newInstance(YourClass.class);

        // Create the Unmarshaller (for converting XML to Java objects)
        Unmarshaller unmarshaller = context.createUnmarshaller();
        return unmarshaller;
    }
}
