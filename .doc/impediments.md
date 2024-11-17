# Poor Type Api
// Finish this point
Cause we haven't a valid danymically api to evaluate type in runtime, we not being able to provide good and precise user experience using mixed but inherently types, Exceptions messages when we have mixed types in series.

public Series(List<Object> data) {
    Type seriesType;
    Type seriesLastType;
    for(Integer i = 0; i < data.size(); i++){
        if(data[i] instanceof Integer){
            seriesType = Integer.class;
        } else if(data[i] instanceof Decimal){
            seriesType = Decimal.class;
        } else if(data[i] instanceof Double){
            seriesType = Double.class;
        } else {
            throw new PandexExceptions.TypeNotSupportedException('Type provided has not been supported yet. Only Integer, Decimal, Double and String are supported for now.');
        }
        if(seriesType != null && seriesType.equals(seriesLastType)){
            throw new PandexExceptions.MixedDataTypesException('The Series Object only support values of the same type.');
        }
        seriesLastType = seriesType;
    }

    this.seriesType = seriesType;
    this.data = data;
}