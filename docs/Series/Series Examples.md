
# Examples

## Statistic Operations
```java
List<Object> data = new List<Object>{ 3, 5, 7, 8, 12, 13, 14, 18, 21 };
Series s = new Series(data);

Decimal sQ25 = s.quantile(.25);
System.debug('sQ25: ' + sQ25); // 7

Integer sSize = s.size(); // Also known as count()
System.debug('sSize: ' + sSize); // 9

List<Object> data2 = new List<Object>{ 1, 30, 304, -2, 3, 5 };
Series s2 = new Series(data2);

Series s2Cummin = s2.cummin();
System.debug('s2Cummin: ' + s2Cummin); // { 1, 1, 1, -2, -2, -2 }

Series s2Cumsum = s2.cumsum();
System.debug('s2Cumsum: ' + s2Cumsum); // { 1, 31, 335, 333, 336, 341 }
```

## Access Operations
```java
List<Object> data = new List<Object>{ 1, 2, 3 };
Series s = new Series(data);

List<Object> data2 = new List<Object>{ 1, 4, 9 };
List<Object> index = new List<Object>{ 'A', 'B', 'C' };
Series s2 = new Series(data2, index);

System.debug('s.row(1): ' + s.row(1)); // 2
System.debug('s.row(\'C\'): ' + s.row('C')); // 9
```

## Other Operations
```java
List<Object> data = new List<Object>{ 1, 2, 3 };
Series s = new Series(data);

List<Object> data2 = new List<Object>{ 1, 4, 9 };
Series s2 = new Series(data2);

System.debug('s.equals(s2).all(): ' + s.equals(s2).all()); // false
System.debug('s.mul(s).equals(s2).all(): ' + s.mul(s).equals(s2).all()); // true
```