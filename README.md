# SfdcObjectFactory
This tool is to help you out create dummy records for salesforce objects. This repo consists of two classes one is the ObjectFactory 
which gives you the records containing dummy data and the DataFactory class which allows to create dummy data of almost any kind 
in salesforce. See the below examples to see how it works:

```java
/*
Let's say we have a custom object with the following structure:

Object Name:Candidate__c:
---------------------------------------------------------------------
| Name -> Text,
| Age__c -> Integer
| Identification__c Text(10) Unique
| status__c -> Picklist('In Progres','Processed','Hold','Denied')
| Process_date__c->Date
---------------------------------------------------------------------
*/


//we create the config files, this is used to pass default values to columns among other things.
ObjectFactory.ObjectConfig config=new ObjectFactory.ObjectConfig();

//we provide the default value we want to have.
config.addDefValue('Name','John');

//this will get a random value based on the default values provided.
config.addDefValue('status__c',new string[]{'In Progres','Processed','Hold'});

/*we want the age to be also random but only containig ages from 25 to 50 inclusive. 
Last parameter indicates the quantities of records.
*/
config.addDefValue('age__c',DataFactory.getRandomIntN(25,50,50));

List<SObject> objs=new List<SObject>();

ObjectFactory facObj=new ObjectFactory();

//we create 100 record for object Candidate__c.
objs.addAll(facObj.getObjects('Candidate__c',config,100));

//finally we insert those records.
insert objs;
```
