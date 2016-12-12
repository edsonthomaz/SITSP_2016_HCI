/*
 * The integration developer needs to create the method processData 
 * This method takes Message object of package com.sap.gateway.ip.core.customdev.util
 * which includes helper methods useful for the content developer:
 * 
 * The methods available are:
    public java.lang.Object getBody()
    
    //This method helps User to retrieve message body as specific type ( InputStream , String , byte[] ) - e.g. message.getBody(java.io.InputStream)
    public java.lang.Object getBody(java.lang.String fullyQualifiedClassName)

    public void setBody(java.lang.Object exchangeBody)

    public java.util.Map<java.lang.String,java.lang.Object> getHeaders()

    public void setHeaders(java.util.Map<java.lang.String,java.lang.Object> exchangeHeaders)

    public void setHeader(java.lang.String name, java.lang.Object value)

    public java.util.Map<java.lang.String,java.lang.Object> getProperties()

    public void setProperties(java.util.Map<java.lang.String,java.lang.Object> exchangeProperties) 

	public void setProperty(java.lang.String name, java.lang.Object value)
 * 
 */
import com.sap.gateway.ip.core.customdev.util.Message;
//import java.util.HashMap;

import twitter4j.Status;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import com.sap.gateway.ip.core.customdev.util.Message;
//import java.util.HashMap;
//import twitter4j.StatusJSONImpl;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Date;
import org.apache.commons.lang.StringEscapeUtils;


def Message processData(Message message) {
	
    def messageLog = messageLogFactory.getMessageLog(message);
    def propertyMap = message.getProperties();

    List<Status> tweets = message.getBody();
    DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
    df.setTimeZone(TimeZone.getTimeZone("propertyMap"));
    
    String xmlHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><TwitterSITSP_Edson_Thomaz><Resultset>";
    
    String xmlTweets = "";
    
    int vencedor = 0;
    
    for (body in tweets) {
        String tweet = "<result>"
        vencedor++;
        if (vencedor == 5 || vencedor == 10 || vencedor == 20) {
        	tweet = tweet + "<Winner>Yes</Winner>";
        } else {
        	tweet = tweet + "<Winner>No</Winner>";
        }
        tweet = tweet + "<Text>"+body.getText()+"</Text><UserScreenName>"+body.getUser().getScreenName()+"</UserScreenName><UserName>"+body.getUser().getName()+"</UserName><tweetDate>"+df.format(body.getCreatedAt())+"</tweetDate></result>";
        xmlTweets = xmlTweets + tweet;
     }
    String xmlFooter = "</Resultset></TwitterSITSP_Edson_Thomaz>";
    
    String outputMessage = xmlHeader + xmlTweets +  xmlFooter;
    message.setBody(outputMessage);
    return message;
}

