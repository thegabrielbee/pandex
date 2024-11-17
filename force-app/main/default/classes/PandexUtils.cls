public with sharing class PandexUtils {
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

    public static SObjectType getSObjectType(SObject data) {
        return data.getSObjectType();
    }
}