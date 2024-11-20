/**
* @author Gabriel Nasicmento - gabriel.carva@protonmail.com
* @description Class designed to hold common utilities for the Framework
**/
public with sharing class PandexUtils {
    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to retrieve the Data Type
    * of a determined value passed by parameter.
    * @param Object data - Data to be evaluted
    **/
    public static Type getPrimitiveType(Object data) {
        Type typeDefined = null;
        if(data instanceof Integer){
            typeDefined = Integer.class;
        } else if(data instanceof Decimal){
            typeDefined = Decimal.class;
        } else if(data instanceof Double){
            typeDefined = Double.class;
        } else if(data instanceof String){
            typeDefined = String.class;
        } else if(data instanceof Boolean){
            typeDefined = Boolean.class;
        }
        return typeDefined;
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to retrieve the Type
    * of a determined SObject.
    * @param SObject data - SObject to be evaluted
    **/
    public static SObjectType getSObjectType(SObject data) {
        return data.getSObjectType();
    }
}