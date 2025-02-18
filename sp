import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.Marshaller;
import jakarta.xml.soap.*;
import org.springframework.stereotype.Service;
import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;

@Service
public class SOAPService {

    public <T> T sendSOAPRequest(Object requestObject, Class<T> responseClass, String endpointUrl, String authToken) {
        try {
            // Step 1: Create SOAP request message
            SOAPMessage soapMessage = createSOAPMessage(requestObject, responseClass);
            String soapMessageStr = getSOAPMessageAsString(soapMessage);
            System.out.println("SOAP Request: " + soapMessageStr);

            // Step 2: Send SOAP request
            SOAPMessage soapResponse = sendSOAPMessage(soapMessage, endpointUrl, authToken);

            // Step 3: Convert SOAP response to Java object
            return convertSOAPToJAXB(soapResponse, responseClass);

        } catch (SOAPException | JAXBException e) {
            throw new CustomSoapException("Error processing SOAP request", e);
        }
    }

    private <T> SOAPMessage createSOAPMessage(T jaxbObject, Class<T> clazz) throws SOAPException, JAXBException {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        SOAPBody soapBody = soapMessage.getSOAPBody();

        JAXBContext jaxbContext = JAXBContext.newInstance(clazz);
        Marshaller marshaller = jaxbContext.createMarshaller();
        marshaller.marshal(jaxbObject, soapBody);

        return soapMessage;
    }

    private SOAPMessage sendSOAPMessage(SOAPMessage soapMessage, String endpointUrl, String authToken) throws SOAPException {
        SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
        SOAPConnection soapConnection = soapConnectionFactory.createConnection();

        // Add Authorization Header
        soapMessage.getMimeHeaders().addHeader("Authorization", "Bearer " + authToken);

        return soapConnection.call(soapMessage, endpointUrl);
    }

    private <T> T convertSOAPToJAXB(SOAPMessage soapMessage, Class<T> clazz) throws JAXBException {
        JAXBContext jaxbContext = JAXBContext.newInstance(clazz);
        return jaxbContext.createUnmarshaller().unmarshal(soapMessage.getSOAPBody(), clazz).getValue();
    }

    private String getSOAPMessageAsString(SOAPMessage soapMessage) {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            soapMessage.writeTo(out);
            return out.toString(StandardCharsets.UTF_8);
        } catch (Exception e) {
            throw new CustomSoapException("Error serializing SOAP message", e);
        }
    }
}
