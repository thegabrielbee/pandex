
# Contructor Examples

## List Constructor
```java
List<Object> data = new List<Object>{ 1, 6546456.2, 34 };
Series s = new Series(data);
// So your Series will look like this:
// 0 	1
// 1 	6546456.2
// 2 	34
```

## Empty Constructor
```java
// Use it when you will insert the Series data later
Series s = new  Series();
```

## With Index Constructor
```java
List<Object> data = new List<Object>{ 1, 6546456.2, 34 };
List<Object> index = new List<Object>{ 'CustomerId', 'Net Worth', 'Age' };

Series s = new Series(data, index);
// So your Series will look like this:
// CustomerId 	1
// Net Worth 	6546456.2
// Age 			34
```