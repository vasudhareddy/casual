import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.Map;

@Configuration
public class JaxbConfig {

    @PostConstruct
    private void setup() {
        // Custom setup logic if necessary
    }

    @Bean
    public Jaxb2Marshaller marshaller() {
        Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
        marshaller.setContextPath("com.fnmis.services.services_common.loansearch._3");

        Map<String, Object> map = new HashMap<>();
        map.put(Jaxb2Marshaller.JAXB_FORMATTED_OUTPUT, true);
        marshaller.setMarshallerProperties(map);
        
        return marshaller;
    }
}
