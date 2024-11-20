/**
* @author Gabriel Nasicmento - gabriel.carva@protonmail.com
* @description Class designed to handle Python Pandas-like Series 
**/
public with sharing class Series {
    public List<Object> data = new List<Object>();
    public List<Object> index = new List<Object>();
    private Type seriesType = null;
    private Set<Type> validTypes = new Set<Type>{ Integer.class, Decimal.class, Double.class, String.class, Boolean.class };
    private Set<Type> numericTypes = new Set<Type>{ Integer.class, Decimal.class, Double.class };

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Empty contructor for Series that initialize empty
    **/
    public Series() {}

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Contructor for Series that initialize with a List of data of the same Type
    * @param List<Object> data - Objects of the same type to be converted into a Series
    *  
    * List<Object> data = new List<Object>{ 1, 6546456.2, 34 };
    * Series s = new Series(data);
    * 
    * So your Series will look like this: 
    *  0         1
    *  1         6546456.2
    *  2         34
    **/
    public Series(List<Object> data) {
        Type seriesType;
        Type seriesLastType;
        List<Object> index = new List<Object>();
        for(Integer i = 0; i < data.size(); i++){
            if(data[i] == null) continue;
            seriesType = PandexUtils.getPrimitiveType(data[i]);
            if(!validTypes.contains(seriesType)) {
                throw new PandexExceptions.TypeNotSupportedException('Type provided has not been supported yet. Only ' + String.join(this.validTypes, ', ') + 'are supported for now.');
            }
            if(seriesType != null && seriesLastType != null && !seriesType.equals(seriesLastType)){
                throw new PandexExceptions.MixedDataTypesException('The Series Object only support values of the same type.');
            }
            seriesLastType = seriesType;
            index.add(i);
        }

        this.index = index;
        this.seriesType = seriesType;
        this.data = data;
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Contructor for Series that initialize with a List of data of the same Type
    * @param List<Object> data - Objects of the same type to be converted into a Series
    *  
    * List<Object> data = new List<Object>{ 1, 6546456.2, 34 };
    * List<Object> index = new List<Object>{ 'CustomerId', 'Net Worth', 'Age' };
    * Series s = new Series(data, index);
    * 
    * So your Series will look like this: 
    *  CustomerId       1
    *  Net Worth        6546456.2
    *  Age              34
    **/
    public Series(List<Object> data, List<Object> index) {
        Integer dataSize = data.size();
        Integer indexSize = data.size();
        if(dataSize != indexSize) {
            throw new PandexExceptions.SizeMismatchException('Data and Index must have the same size: ' + data + 'X' + indexSize);
        }
        Type seriesType;
        Type seriesLastType;
        for(Integer i = 0; i < dataSize; i++){
            if(data[i] == null) continue;
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
        this.index = index;
        this.data = data;
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to append data into the final  
    * of a Series.
    * @param Object data - Data to be inserted * Must be of the same type of the Series
    **/
    public void add(Object data){
        Type seriesType = PandexUtils.getPrimitiveType(data);
        if(this.seriesType != null && seriesType != this.seriesType) {
            throw new PandexExceptions.MixedDataTypesException('The Series Object only support values of the same type.');
        }

        this.data.add(data);
        this.index.add(this.index.size());

        if(this.seriesType == null && seriesType != null) {
            this.seriesType = seriesType;
        }
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to Sum 2 different Series and
    * return another one with the Added values.
    * @param Series s - Series to be Added * Must be of a numeric 
    * type and have the same size of the base Series being Added
    **/
    public Series sum(Series s){
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType) || !this.numericTypes.contains(s.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Sum operation is only supperted by Series of Numeric Types');
        }

        if(this.size() != s.size()){
            throw new PandexExceptions.SizeMismatchException('Can\'t sum two Series with different Sizes.');
        }

        List<Decimal> sumValues = new List<Decimal>(); 
        for(Integer i = 0; i < this.data.size(); i++){
            sumValues.add((Decimal) this.data[i] + (Decimal) s.data[i]);
        }
        return new Series(sumValues);
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to Subtract 2 different Series and
    * return another one with the Subtracted values.
    * @param Series s - Series to be Subtracted * Must be of a numeric
    * type and have the same size of the base Series being Subtracted
    **/
    public Series sub(Series s){
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType) || !this.numericTypes.contains(s.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Subtraction operation is only supperted by Series of Numeric Types');
        }

        if(this.size() != s.size()){
            throw new PandexExceptions.SizeMismatchException('Can\'t sub two Series with different Sizes.');
        }

        List<Decimal> subValues = new List<Decimal>(); 
        for(Integer i = 0; i < this.data.size(); i++){
            subValues.add((Decimal) this.data[i] - (Decimal) s.data[i]);
        }
        return new Series(subValues);
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to Multiply 2 different Series and
    * return another one with the Multiplied values.
    * @param Series s - Series to be Multiplied * Must be of a numeric
    * type and have the same size of the base Series being Multiplied
    **/
    public Series mul(Series s){
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType) || !this.numericTypes.contains(s.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Multiplication operation is only supperted by Series of Numeric Types');
        }

        if(this.size() != s.size()){
            throw new PandexExceptions.SizeMismatchException('Can\'t mul two Series with different Sizes.');
        }

        List<Decimal> mulValues = new List<Decimal>(); 
        for(Integer i = 0; i < this.data.size(); i++){
            mulValues.add((Decimal) this.data[i] * (Decimal) s.data[i]);
        }
        return new Series(mulValues);
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to Divide 2 different Series and
    * return another one with the Divided values.
    * @param Series s - Series to be Divided * Must be of a numeric
    * type and have the same size of the base Series being Divided
    **/
    public Series div(Series s){
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType) || !this.numericTypes.contains(s.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Division operation is only supperted by Series of Numeric Types');
        }

        if(this.size() != s.size()){
            throw new PandexExceptions.SizeMismatchException('Can\'t div two Series with different Sizes.');
        }

        List<Decimal> divValues = new List<Decimal>(); 
        for(Integer i = 0; i < this.data.size(); i++){
            divValues.add((Decimal) this.data[i] / (Decimal) s.data[i]);
        }
        return new Series(divValues);
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to return the Size of the Series
    **/
    public Integer size() {
        return this.data.size();
    }
    
    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to return the value in the
    * passed index.
    * @param Integer rowIndex - Index to be retrieved
    **/
    public Object row(Integer rowIndex) {
        Integer index = this.index.indexOf(rowIndex);
        if(index == -1) {
            throw new PandexExceptions.AccessException('The index provided is out of bounds.');
        }
        return this.data[index];
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to return the value in the
    * passed index.
    * @param String rowIndex - Index to be retrieved
    **/
    public Object row(String rowIndex) {
        Integer index = this.index.indexOf(rowIndex);
        if(index == -1) {
            throw new PandexExceptions.AccessException('The index provided is out of bounds.');
        }
        return this.data[index];
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed to compare the scalar equality 
    * of two Series of the same type and size.
    * @param Series s - Series to be compared
    * List<Object> data = new List<Object>{ 1, 6546456.2, 34 };
    * List<Object> data2 = new List<Object>{ 1, 3214321.56, 34 };
    * Series s = new Series(data);
    * Series s2 = new Series(data2);
    * 
    * So s.equals(s2) will look like:
    *  0         true
    *  1         false
    *  2         true
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Method designed evaluate if all values of a
    * Boolean Series are true.
    **/
    public Boolean all() {
        if(this.seriesType != Boolean.class) {
            throw new PandexExceptions.MixedDataTypesException('Can\'t use this operation with series that aren\'t Boolean.');
        }
        Boolean isAll = true;
        if(this.data.isEmpty()) return isAll;
        for(Integer i = 0; i < this.data.size(); i++){
            if(!(Boolean) data[i]) return false;
        }
        return isAll;
    }

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Calculate the Mean/Avarage of the Series
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Calculate the Sum of the Series
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Calculate the Median of the Series
    **/
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


    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Calculate the Standard Deviation of the Series
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Return the Maximun scalar of the Series
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Return the Minimun scalar of the Series
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Calculate the Product of the Series
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Calculate the Variance of the Series
    **/
    public Decimal var() {
        if(this.data.isEmpty()) return null;
        // Throws a exception if the data is not numeric
        if(!this.numericTypes.contains(this.seriesType)){
            throw new PandexExceptions.InvalidDataTypeException('Variance operation not supported on the type of this Series: ' + String.valueOf(this.data[0]));
        }

        return (Decimal) Math.pow((Double) this.std(), 2);
    }
    
    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Return a Series that is the Cummulative Sum 
    * of the actual Series
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Return a Series that is the Cummulative Product 
    * of the actual Series
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Return a Series that is the Cummulative Minimun 
    * of the actual Series
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Return a Series that is the Cummulative Maximun 
    * of the actual Series
    **/
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

    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Return a Quantile(q) value of the Series
    * @param Decimal q - The quantile to be returned
    **/
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