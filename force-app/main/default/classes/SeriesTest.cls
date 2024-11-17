@IsTest
public with sharing class SeriesTest {
    
    @isTest
    public static void seriesMustNotSupportMixedTypes() {
        List<Object> data = new List<Object>{ 'Gabriel', 1 };
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                Series s = new Series(data);
            } catch (PandexExceptions.MixedDataTypesException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series must not have be able to handle mixed types in there.');
    }

    @isTest
    public static void meanShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.mean();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void meanShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304 };
        Decimal expectedMean = (1.0 + 30.0 + 304.0) / 3;
        Series s = new Series(data);
        Test.startTest();
            Decimal resultedMean = s.mean();
        Test.stopTest();
        Assert.areEqual(expectedMean, resultedMean, 'Expected: ' + String.valueOf(expectedMean) + ' and received: ' + String.valueOf(resultedMean));
    }

    @isTest
    public static void sumShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.sum();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void sumShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304 };
        Decimal expectedSum = 1.0 + 30.0 + 304.0;
        Series s = new Series(data);
        Test.startTest();
            Decimal resultedSum = s.sum();
        Test.stopTest();
        Assert.areEqual(expectedSum, resultedSum, 'Expected: ' + String.valueOf(expectedSum) + ' and received: ' + String.valueOf(resultedSum));
    }

    @isTest
    public static void medianShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.median();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void medianShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304 };
        Decimal expected = (Decimal) data[data.size() / 2];
        Series s = new Series(data);

        List<Object> data2 = new List<Object>{ 1, 30, 304, 40 };
        Decimal expected2 = ((Decimal) data2[data2.size() / 2] + (Decimal) data2[data2.size() / 2 - 1]) / 2;
        Series s2 = new Series(data2);

        List<Object> data3 = new List<Object>{ };
        Decimal expected3 = null;
        Series s3 = new Series(data3);

        Test.startTest();
            Decimal resulted = s.median();
            Decimal resulted2 = s2.median();
            Decimal resulted3 = s3.median();
        Test.stopTest();

        Assert.areEqual(expected, resulted);
        Assert.areEqual(expected2, resulted2);
        Assert.isNull(resulted3);
    }

    @isTest
    public static void stdShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.std();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void stdShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304 };
        Double mean = (Double) ((Decimal) data[0] + (Decimal) data[1] + (Decimal) data[2]) / data.size();
        Decimal sumStd = 0;
        for(Integer i = 0; i < data.size(); i++){
            sumStd  += (Decimal) Math.pow(((Double) data[i]) - (Double) mean, 2);
        }
        Decimal expected = sumStd / data.size();
        Series s = new Series(data);

        List<Object> data2 = new List<Object>{ };
        Series s2 = new Series(data2);

        Test.startTest();
            Decimal resulted = s.std();
            Decimal resulted2 = s2.std();
        Test.stopTest();

        Assert.areEqual(expected, resulted);
        Assert.isNull(resulted2);
    }

    @isTest
    public static void minShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.min();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void minShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304, -23, 30, 0, -453 };
        List<Object> data2 = new List<Object>{ };
        Double expected = (Decimal) data[data.size()-1];
        Series s = new Series(data);
        Series s2 = new Series(data2);

        Test.startTest();
            Decimal resulted = s.min();
            Decimal resulted2 = s2.min();
        Test.stopTest();

        Assert.areEqual(expected, resulted);
        Assert.isNull(resulted2);
    }

    @isTest
    public static void maxShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.max();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void maxShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304, -23, 30, 0, -453 };
        List<Object> data2 = new List<Object>{};
        Double expected = (Decimal) data[2];
        Series s = new Series(data);
        Series s2 = new Series(data2);

        Test.startTest();
            Decimal resulted = s.max();
            Decimal resulted2 = s2.max();
        Test.stopTest();

        Assert.areEqual(expected, resulted);
        Assert.isNull(resulted2);
    }

    @isTest
    public static void prodShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.prod();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void prodShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304 };
        List<Object> data2 = new List<Object>{};
        Double expected = (Decimal) data[0] * (Decimal) data[1] * (Decimal) data[2];
        Series s = new Series(data);
        Series s2 = new Series(data2);

        Test.startTest();
            Decimal resulted = s.prod();
            Decimal resulted2 = s2.prod();
        Test.stopTest();

        Assert.areEqual(expected, resulted);
        Assert.isNull(resulted2);
    }

    @isTest
    public static void cumsumShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.cumsum();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void cumsumShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304 };
        List<Object> dataCumsum = new List<Object>{};
        List<Object> data2 = new List<Object>{};

        Decimal cumsumValue = 0;
        for(Integer i = 0; i < data.size(); i++){
            dataCumsum.add((Decimal) data[i] + cumsumValue);
            cumsumValue += (Decimal) data[i];
        }
        Series expected = new Series(dataCumsum);

        Series s = new Series(data);
        Series s2 = new Series(data2);

        Test.startTest();
            Series resulted = s.cumsum();
            Series resulted2 = s2.cumsum();
        Test.stopTest();

        Assert.isTrue(expected.equals(resulted).all());
        Assert.isNull(resulted2);
    }

    @isTest
    public static void cumprodShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.cumprod();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void cumprodShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304 };
        List<Object> dataCumprod = new List<Object>{};
        List<Object> data2 = new List<Object>{};

        Decimal cumprodValues = 0;
        for(Integer i = 0; i < data.size(); i++){
            dataCumprod.add((Decimal) data[i] * cumprodValues);
            cumprodValues *= (Decimal) data[i];
        }
        Series expected = new Series(dataCumprod);

        Series s = new Series(data);
        Series s2 = new Series(data2);

        Test.startTest();
            Series resulted = s.cumprod();
            Series resulted2 = s2.cumprod();
        Test.stopTest();

        Assert.isTrue(expected.equals(resulted).all());
        Assert.isNull(resulted2);
    }

    @isTest
    public static void cumminShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.cummin();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void cumminShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304, -2, 3, 5 };
        List<Object> data2 = new List<Object>{};
        Series expected = new Series(new List<Object>{ 1, 1, 1, -2, -2, -2 });

        Series s = new Series(data);
        Series s2 = new Series(data2);

        Test.startTest();
            Series resulted = s.cummin();
            Series resulted2 = s2.cummin();
        Test.stopTest();

        Assert.isTrue(expected.equals(resulted).all());
        Assert.isNull(resulted2);
    }

    @isTest
    public static void cummaxShouldNotBeDoneWithNonNumericFields() {
        List<Object> data = new List<Object>{ 'Gabriel', 'Carvalho', 'Nascimento' };
        Series s = new Series(data);
        Boolean errorWasRaised = False;
        Test.startTest();
            try {
                s.cummax();
            } catch (PandexExceptions.InvalidDataTypeException e) {
                errorWasRaised = true;
            }
        Test.stopTest();
        Assert.isTrue(errorWasRaised, 'This series has non numeric and should raise an error.');
    }

    @isTest
    public static void cummaxShouldBeDoneWithNumericFields() {
        List<Object> data = new List<Object>{ 1, 30, 304, -2, 3, 5 };
        List<Object> data2 = new List<Object>{};
        Series expected = new Series(new List<Object>{ 1, 30, 304, 304, 304, 304 });

        Series s = new Series(data);
        Series s2 = new Series(data2);

        Test.startTest();
            Series resulted = s.cummax();
            Series resulted2 = s2.cummax();
        Test.stopTest();

        Assert.isTrue(expected.equals(resulted).all());
        Assert.isNull(resulted2);
    }
}