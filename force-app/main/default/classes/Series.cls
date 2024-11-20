public with sharing class Series {
    public List<Object> data = null;
    private Type seriesType = null;
    private Set<Type> validTypes = new Set<Type>{ Integer.class, Decimal.class, Double.class, String.class, Boolean.class };
    private Set<Type> numericTypes = new Set<Type>{ Integer.class, Decimal.class, Double.class };

    public Series(List<Object> data) {
        Type seriesType;
        Type seriesLastType;
        for(Integer i = 0; i < data.size(); i++){
            seriesType = PandexUtils.getPrimitiveType(data[i]);
            if(!validTypes.contains(seriesType)) {
                throw new PandexExceptions.TypeNotSupportedException('Type provided has not been supported yet. Only ' + String.join(this.validTypes, ', ') + 'are supported for now.');
            }
            if(seriesType != null && seriesLastType != null && !seriesType.equals(seriesLastType)){
                throw new PandexExceptions.MixedDataTypesException('The Series Object only support values of the same type.');
            }
            seriesLastType = seriesType;
        }

        this.seriesType = seriesType;
        this.data = data;
    }

    public Series equals(Series s) {
        if (this.data.size() != s.data.size()) {
            throw new PandexExceptions.SizeMismatchException('Can\'t compare two Series with different Sizes.');
        }
        if(this.seriesType != s.seriesType && !this.numericTypes.contains(this.seriesType) && !this.numericTypes.contains(s.seriesType)){
            throw new PandexExceptions.MixedDataTypesException('Can\'t compare two Series with different types.' + this.seriesType + ' != ' + s.seriesType);
        }
        List<Object> data = new List<Object>();
        for(Integer i = 0; i < this.data.size(); i++){
            data.add(this.data[i] == s.data[i]);
        }
        return new Series(data);
    }

    public Boolean all() {
        if(this.seriesType != Boolean.class) {
            throw new PandexExceptions.MixedDataTypesException('Can\'t use this operation with series that aren\'t Boolean.');
        }
        Boolean isAll = true;
        if(this.data == null || this.data.isEmpty()) return isAll;
        for(Integer i = 0; i < this.data.size(); i++){
            if(!(Boolean) data[i]) return false;
        }
        return isAll;
    }

    public Decimal mean() {
        if(this.data.isEmpty()) return 0;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Mean operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        Decimal sum = 0;
        Integer counter = 0;
        for(Integer i = 0; i < this.data.size(); i++){
            sum  += (Decimal) this.data[i];
            counter  += 1;
        }
        return sum / counter;
    }

    public Decimal sum() {
        if(this.data.isEmpty()) return 0;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Sum operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        Decimal sum = 0;
        for(Integer i = 0; i < this.data.size(); i++){
            sum  += (Decimal) this.data[i];
        }
        return sum;
    }

    public Decimal median() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Median operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        List<Object> data = this.data.clone();
        data.sort();
        
        Integer seriesSize = data.size();
        Integer midIndex = seriesSize / 2;
        if(Math.mod(seriesSize, 2) == 0){
            return ((Decimal) data[midIndex - 1] + (Decimal) data[midIndex]) / 2;
        } else {
            return (Decimal) data[midIndex];
        }
    }


    public Decimal std() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Standard Deviation operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        Decimal mean = this.mean();
        Decimal sumStd = 0;
        for(Integer i = 0; i < this.data.size(); i++){
            sumStd  += (Decimal) Math.pow(((Double) this.data[i]) - (Double) mean, 2);
        }
        return sumStd / this.data.size();
    }

    public Decimal max() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Max operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        Decimal max = (Decimal) this.data[0];
        for(Integer i = 1; i < this.data.size(); i++){
            max = Math.max((Decimal) this.data[i], max); 
        }
        return max;
    }

    public Decimal min() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Min operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        Decimal min = (Decimal) this.data[0];
        for(Integer i = 1; i < this.data.size(); i++){
            min = Math.min((Decimal) this.data[i], min); 
        }
        return min;
    }

    public Decimal prod() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Product operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        Decimal prod = (Decimal) this.data[0];
        for(Integer i = 1; i < this.data.size(); i++){
            prod *= (Decimal) this.data[i]; 
        }
        return prod;
    }

    public Decimal var() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Variance operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        return (Decimal) Math.pow((Double) this.std(), 2);
    }
    
    public Series cumsum() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Cumulative Sum operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        List<Decimal> data = new List<Decimal>(); 
        Decimal cumsumValue = 0;
        for(Integer i = 0; i < this.data.size(); i++){
            data.add((Decimal) this.data[i] + cumsumValue);
            cumsumValue += (Decimal) this.data[i];
        }
        return new Series(data);
    }

    public Series cumprod() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Cumulative Product operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        List<Decimal> data = new List<Decimal>(); 
        Decimal cumprodValue = 0;
        for(Integer i = 0; i < this.data.size(); i++){
            data.add((Decimal) this.data[i] * cumprodValue);
            cumprodValue *= (Decimal) this.data[i];
        }
        return new Series(data);
    }

    public Series cummin() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Cumulative Minimun operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        Decimal minimun = (Decimal) this.data[0];
        List<Decimal> data = new List<Decimal>{ minimun }; 
        for(Integer i = 1; i < this.data.size(); i++){
            if(minimun > (Decimal) this.data[i]) {
                minimun = (Decimal) this.data[i];
            }
            data.add(minimun);
        }
        return new Series(data);
    }

    public Series cummax() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Cumulative Maximun operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        Decimal maximun = (Decimal) this.data[0];
        List<Decimal> data = new List<Decimal>{ maximun }; 
        for(Integer i = 1; i < this.data.size(); i++){
            if(maximun < (Decimal) this.data[i]) {
                maximun = (Decimal) this.data[i];
            }
            data.add(maximun);
        }
        return new Series(data);
    }

    public Integer count() {
        if(this.data.isEmpty()) return 0;
        Integer countValue = 0;
        for(Integer i = 0; i < this.data.size(); i++){
            countValue += 1;
        }
        return countValue;
    }

    public Decimal quantile(Decimal q) {
        if(q < 0 || q > 1) {
            throw new PandexExceptions.ParameterException('Quantile (q) must be between 0 and 1. You pass: ' + String.valueOf(q) + '.');
        }
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Quantile operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        List<Object> data = this.data.clone();
        data.sort();
        Integer k = (Integer) Math.floor(q * (data.size() - 1));
        return (Decimal) data.get(k);
    }
}