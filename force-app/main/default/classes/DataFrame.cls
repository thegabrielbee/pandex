public with sharing class DataFrame {
    public DataFrame(List<SObject> data) {
        SObjectType sObjectType;
        SObjectType lastSObjectType;
        List<Map<String, Object>> values = new List<Map<String, Object>>();
        for(Integer i = 0; i < data.size(); i++) {
            sObjectType = PandexUtils.getSObjectType(data[i]);
            if(sObjectType != null && lastSObjectType != null && !sObjectType.equals(lastSObjectType)){
                throw new PandexExceptions.MixedDataTypesException('The Series Object only support values of the same type.');
            }
            values.add(data.getPopulatedFieldsAsMap());
            lastSObjectType = sObjectType;
        }
    }
}