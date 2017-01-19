# Kibana query cheatsheet
* ```Be careful with the * wildcard. It can overload ELK stack easily```
* https://www.timroes.de/2016/05/29/elasticsearch-kibana-queries-in-depth-tutorial/

| Query                         |
| ------------- | -------------:|
| Match field      | field1­:"qu­ery­_te­rm" |
| Field contains A or B      | field1:(term1 OR term2)      |
| Field contains A and B | field1:(term1 AND term2)      |
| Field missing  |  _missi­ng_­:field     |
| Field exists  |   _exist­s_:­title    |


| Wildcards                         |
| ------------- | -------------:|
|Single character| ?|
|Multiple characters| *|
|Fuzzy |~|

| Boolean Operations                         |
| ------------- | -------------:|
|Must be Present|+|
|Must not be present|- |
|And |AND &&
|or |OR &#124;&#124;|
|Not |NOT ! |


| Grouping - Boolean logic combined with brackets |
| ------------- |
| Must contain either or both term1/­term2 and term3 (term1 OR term2) AND term3 |

| Ranges                         |
| ------------- | -------------:|
|1 to 5, including 1 and 5 |[ 1 TO 5 ] |
|1 to 5, excluding 1 and 5 | { 1 TO 5 } |
|1 to 5, including 1, excluding 5 | [1 to 5}|
|All days in 2012 | [2012-­01-01 TO 2012-1­2-31]|
|Larger then 3|>3|
|Smaller then 3|<3|
|Larger or equal to 3|>=3|
|Smaller or equal to 3|<=3|

|Reserved characters|
| ------------- | -------------:|
|Reserved|+ - = && &#124;&#124; > < ! ( ) { } [ ] ^ " ~ * ? : \ /|
|Break character | \ |
|For instance, to search for (1+1)=2, you would need to write your query as:| \(1\+1­\)\=2|


# Credits
- https://www.cheatography.com/swaglord/cheat-sheets/kibana/pdf/
- http://elasticsearch-cheatsheet.jolicode.com/
