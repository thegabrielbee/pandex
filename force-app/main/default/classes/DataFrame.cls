public with sharing class DataFrame {
    public Map<String, Series> columns = new Map<String, Series>();

    public DataFrame() {}
    public DataFrame(List<SObject> data) {
        SObjectType sObjectType;
        SObjectType lastSObjectType;
        List<Map<String, Object>> values = new List<Map<String, Object>>();
        Integer dataSize = data.size();
        Set<String> biggerProperties =  new Set<String>();
        Integer biggerPropertiesSize = 0;
        for(Integer i = 0; i < dataSize; i++) {
            sObjectType = PandexUtils.getSObjectType(data[i]);
            if(sObjectType != null && lastSObjectType != null && !sObjectType.equals(lastSObjectType)){
                throw new PandexExceptions.MixedDataTypesException('The Series Object only support values of the same type');
            }
            Map<String, Object> objectProperties = data[i].getPopulatedFieldsAsMap();
            Integer objectPropertiesSize = objectProperties.size();
            if(objectPropertiesSize > biggerPropertiesSize) {
                biggerProperties = objectProperties.keySet();
                biggerPropertiesSize = objectPropertiesSize;
            }
            values.add(objectProperties);
            lastSObjectType = sObjectType;
        }
        Map<String, Series> columns = new Map<String, Series>();
        for(Integer i = 0; i < dataSize; i++) {
            for(String seriesKey: biggerProperties) {
                Object recordPropertyValue = null;
                if(values[i].containsKey(seriesKey)) {
                    recordPropertyValue = values[i].get(seriesKey);
                }
                if(columns.containsKey(seriesKey)){
                    columns.get(seriesKey).add(recordPropertyValue);
                } else {
                    columns.put(seriesKey, new Series(new List<Object>{ recordPropertyValue }));
                }
            }
        }
        this.columns = columns;
    }

    public DataFrame(Map<String, List<Object>> data) {
        Integer lastSize = null;
        Integer actualSize;
        for(String seriesKey: data.keySet()) {
            List<Object> dataList = data.get(seriesKey);
            actualSize = dataList.size();
            if(lastSize != null && lastSize != actualSize){
                throw new PandexExceptions.SizeMismatchException('All columns must have the same size');
            }
            columns.put(seriesKey, new Series(dataList));
            lastSize = actualSize;
        }

        this.columns = columns;
    }

    public DataFrame(List<Object> data) {
        columns = new Map<String, Series>{
            '0' => new Series(data)
        };
        this.columns = columns;
    }

    public DataFrame(List<List<Object>> data) {
        columns = new Map<String, Series>();
        Integer lastSize = null;
        Integer actualSize;
        for(Integer i = 0; i < data.size(); i++) {
            actualSize = data[i].size();
            if(lastSize != null && lastSize != actualSize){
                throw new PandexExceptions.SizeMismatchException('All columns must have the same size');
            }
            columns.put(String.valueOf(i), new Series(data[i]));
            lastSize = actualSize;
        }
        this.columns = columns;
    }

    public Series col(String colName){
        if(!this.columns.containsKey(colName)){
            throw new PandexExceptions.AccessException('DataFrame don\'t have a columns named: ' + colName);
        }
        return this.columns.get(colName);       
    }

    public Series row(Integer rowIndex){
        List<Object> data = new List<Object>();
        List<Object> index = new List<Object>();
        for(String seriesKey: this.columns.keySet()) {
            data.add(this.columns.get(seriesKey).row(rowIndex));
            index.add(seriesKey);
        }
        return new Series(data, index);       
    }
}