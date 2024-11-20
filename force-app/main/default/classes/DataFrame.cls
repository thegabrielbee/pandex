/**
* @author Gabriel Nasicmento - gabriel.carva@protonmail.com
* @description Class designed to handle Python Pandas-like DataFrame 
**/
public with sharing class DataFrame {
    public Map<String, Series> columns = new Map<String, Series>();

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Empty contructor for DataFrames that initialize empty
    **/
    public DataFrame() {}
    
    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Contructor for DataFrames that initialize with SObjects of the same type
    * @param List<SObject> data - SObjects of the same type to be converted into a DataFrame
    *  
    * Case c1 = new Case(Subject='Why Pandex is so amazing?');
    * Case c2 = new Case(Subject='Because he is made by amazing people!', Priority='High');
    * List<SObject> data = new List<SObject>{ c1, c2 }; 
    * DataFrame df = new DataFrame(data);
    * 
    * So your DataFrame will look like this:
    *            Subject                               |    Priority
    *  0         Why Pandex is so amazing?             |    null
    *  1         Because he is made by amazing people! |    High
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Contructor for DataFrames that initialize with Maps
    * @param Map<String,List<Object>> data - Map (Column=>Row) to be converted into a DataFrame
    * 
    * List<Object> customerIds = new List<Object>{ 1, 2, 3 };
    * List<Object> invoiceValues = new List<Object>{ 2213.321, 432423.3, 5435443.2};
    * 
    * Map<String, List<SObject>> data = new Map<String, List<SObject>>{ 
    *    'customerIds' => customerIds,
    *    'invoiceValues' => invoiceValues
    * };
    *
    * DataFrame df = new DataFrame(data);
    * 
    * So your DataFrame will look like this:
    *            customerIds    |   invoiceValues
    *  0         1              |   2213.321
    *  1         2              |   432423.3
    *  2         3              |   5435443.2
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Contructor for DataFrames that initialize with a List
    * @param List<Object> data - List to be converted into a DataFrame
    * 
    * List<Object> data = new List<Object>{ 43, 21, 34 };
    * 
    * DataFrame df = new DataFrame(data);
    * 
    * So your DataFrame will look like this:
    *            0      
    *  0         43      
    *  1         21      
    *  2         34
    **/
    public DataFrame(List<Object> data) {
        columns = new Map<String, Series>{
            '0' => new Series(data)
        };
        this.columns = columns;
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Contructor for DataFrames that initialize with Matrix
    * @param List<List<Object>> data - Matrix to be converted into a DataFrame
    * 
    * List<Object> costumer1Data = new List<Object>{ 1, 6546456.2, 34 };
    * List<Object> costumer2Data = new List<Object>{ 2, 432423.34, 48 };
    * 
    * List<List<Object>> data = new List<List<Object>> { 
    *    costumer1Data,
    *    costumer2Data
    * }; 
    * DataFrame df = new DataFrame(data);
    * 
    * So your DataFrame will look like this:
    *            0      |           1               |       2
    *  0         1      |           6546456.2       |       34
    *  1         2      |           432423.34       |       48
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to retrieve a specific column from a DataFrame
    * @param String colName - Name of the column to be retrieved
    **/
    public Series col(String colName){
        if(!this.columns.containsKey(colName)){
            throw new PandexExceptions.AccessException('DataFrame don\'t have a columns named: ' + colName);
        }
        return this.columns.get(colName);       
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to retrieve a specific row from a DataFrame
    * @param Integer rowIndex - Index of the row to be retrieved
    **/
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