public with sharing class PandexExceptions {
    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Must be used when a operation is done using
    * a non supported type. 
    **/
    public class InvalidDataTypeException extends Exception {}
    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Must be used when a Series is trying to be created
    * with diferent types values. 
    **/
    public class MixedDataTypesException extends Exception {}
    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Must be used when a Series is trying to be created
    * with a non supperted Data Type. 
    **/
    public class TypeNotSupportedException extends Exception {}
    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Must be used when a DataFrame is trying to be
    * created with Rows with different Sizes. 
    **/
    public class SizeMismatchException extends Exception {}
    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Must be used when a Parameter doesn't meet
    * the operation requirements. * Like Quantile that q,
    * must be beetween 0 and 1.
    **/
    public class ParameterException extends Exception {}
    /**
    * @author Gabriel Nasicmento - gabriel.carva@protonmail.com
    * @description Must be used when an wrong access is trying
    * to be performed. Like a Column or Row that's not exists.  
    **/
    public class AccessException extends Exception {}
}