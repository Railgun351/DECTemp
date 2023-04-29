package utils;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public class Utils {
	 public static String getBody(HttpServletRequest request) throws IOException {
    	 
	        String body = null;
	        StringBuilder stringBuilder = new StringBuilder();
	        BufferedReader bufferedReader = null;
	 
	        try {
	            InputStream inputStream = request.getInputStream();
	            if (inputStream != null) {
	                bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
	                char[] charBuffer = new char[128];
	                int bytesRead = -1;
	                while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
	                    stringBuilder.append(charBuffer, 0, bytesRead);
	                }
	            }
	        } catch (IOException ex) {
	            throw ex;
	        } finally {
	            if (bufferedReader != null) {
	                try {
	                    bufferedReader.close();
	                } catch (IOException ex) {
	                    throw ex;
	                }
	            }
	        }
	 
	        body = stringBuilder.toString();
	        return body;
	    }
	    
	    public static Map<String, String> getQueryMap(String query){    	
	    	if (query==null || query =="") return null;
	    	
	    	int pos1=query.indexOf("?");
	    	if (pos1>=0) {
	    		query=query.substring(pos1+1);
	    	}
	    	
	        String[] params = query.split("&");
	        Map<String, String> map = new HashMap<String, String>();
	        for (String param : params)
	        {
	            String name = param.split("=")[0];
	            String value = param.split("=").length < 2 ? null : param.split("=")[1];
	            map.put(name, value);
	        }
	        return map;
	    }
	    
	    public static boolean isNumeric(String s) {
			  try {
			      Integer.parseInt(s);
			      return true;
			  } catch(NumberFormatException e) {
			      return false;
			  }
		}
}
