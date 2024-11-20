# Contructor Examples
## SObject Constructor
```java
Case c1 = new Case(Subject='Why Pandex is so amazing?');
Case c2 = new Case(Subject='Because he is made by amazing people!', Priority='High');
List<Case> data = new List<Case>{ c1, c2 };
// Or you can user a query [SELECT SUBJECT, PRIORITY, ..., DESCRIPTION  FROM CASE WHERE ...];

DataFrame df = new DataFrame(data);
// So your DataFrame will look like this:
//
//		Subject 								| 	Priority
// 0 	Why Pandex is so amazing? 				| 	null
// 1 	Because he is made by amazing people! 	| 	High
```

## Empty Constructor
```java
// Use it when you will insert the DataFrame data later
DataFrame df = new DataFrame();
```

## Map Constructor
```java
List<Object> customerIds = new List<Object>{ 1, 2, 3 };
List<Object> invoiceValues = new List<Object>{ 2213.321, 432423.3, 5435443.2 };
Map<String, List<SObject>> data = new Map<String, List<SObject>>{
	'customerIds' => customerIds,
	'invoiceValues' => invoiceValues
};

DataFrame df = new DataFrame(data);
//So your DataFrame will look like this:
// 		customerIds | 	invoiceValues
// 0 	1 			| 	2213.321
// 1 	2 			| 	432423.3
// 2 	3 			| 	5435443.2
```

## List Constructor
```java
List<Object> data = new List<Object>{ 43, 21, 34 };

DataFrame df = new DataFrame(data);
// So your DataFrame will look like this:
// 		0
// 0 	43
// 1 	21
// 2 	34
```

## Matrix Constructor
```java
List<Object> costumer1Data = new List<Object>{ 1, 6546456.2, 34 };
List<Object> costumer2Data = new List<Object>{ 2, 432423.34, 48 };
List<List<Object>> data = new List<List<Object>> {
	costumer1Data,
	costumer2Data
};

DataFrame df = new DataFrame(data);
// So your DataFrame will look like this:
// 		0 	| 	1 			| 	2
// 0 	1 	| 	6546456.2 	| 	34
// 1 	2 	| 	432423.34 	| 	48

```
