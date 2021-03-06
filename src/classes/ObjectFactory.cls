/**
 * Author:Andres K. Tejada(andres.tejada27@gmail.com)
 * Description: Class to generate objects of any kind in sfdc with data dummy or predefined
 **/
public class ObjectFactory {

    public class ObjectConfig{
        public map<string,object> defValues{get;private set;}
        
        public void addDefValue(string column,object value){
            defValues.put(column.toLowerCase(),value);
        }
        
        private string cols;
        public boolean useOnlyDefault{get;set;}
        public string excludedCols{
            set{
                cols=value.toLowerCase();
                List<string> listCols=cols.split(',');
                excludedColumns=new Set<string>(listCols);
            }
        }
        public ObjectConfig(){
            defValues=new map<string,object>();
        }
       public Set<string> excludedColumns{private set;get;}
        
    }
    
    private Map<string,Schema.SObjectType> schemaMap;
    private map<string,DescribeFieldResult> fieldsDescribe;
    public ObjectFactory(){
        schemaMap=Schema.getGlobalDescribe();
    }
    
    //Get List<objects> for an object name
    public List<sObject> getObjects(string name,ObjectConfig config,integer count){
        
         //populate fields
        this.getFields(name);
        List<SObject> listObjs=new List<SObject>();
        map<string,object> fieldsObj=this.getFieldsData(name);
        integer num=1;
        while(num<=count){
            
            Sobject obj=schemaMap.get(name).newSObject();
            
            for(string key:fieldsObj.keySet()){
                
                if(config.defValues!=null && config.defValues.containsKey(key.toLowerCase())){
                    Object val=config.defValues.get(key.toLowerCase());
                    if(val instanceof List<Object>){
                        List<Object> listOptions=(List<Object>)val;
                        //check if multiple options are included
                        if(listOptions.size()>1){
                          obj.put(key,DataFactory.getRandomItem(listOptions));    
                        }
                    }
                    else{
                        //system.debug('date value==>'+val);
                        obj.put(key,val);    
                    }
                }
                else{
                    if(config.useOnlyDefault==true || (config.excludedColumns!=null && config.excludedColumns.contains(key.toLowerCase())))
                        continue;
                    
                    //system.debug('key to insert==>'+key);
                    obj.put(key,fieldsObj.get(key));
                }
                
                //isUnique()
                if(fieldsDescribe.get(key).isUnique() && config.defValues.containsKey(key.toLowerCase())==false){
                    string valObj=(string)obj.get(key);
                    obj.put(key,valObj+DataFactory.getRandomInt(10,90));
                }
            }
            //hard coded for this case, which not allowed setting OwnerId
            if(name.toLowerCase()!='opportunitylineitem'){
                obj.put('OwnerId', userInfo.getUserId());
                
                //check if the name is writeable
                if(fieldsDescribe.containsKey('Name')){
                    obj.put('Name',obj.get('Name')+'-'+num);//include the number for name        
                }
                
            }
            num=num+1;
            listObjs.add(obj);
        }
        return listObjs;
    }
    
    //Get objects for an object name
    public sObject getObject(string name,ObjectConfig config){
        
        List<sObject> objects=getObjects(name,config,1);
        return (objects.size()>0 ? objects.get(0) : null);        
    }
    
    public map<string,DescribeFieldResult> getFields(string objName) {
        
       fieldsDescribe=new map<string,DescribeFieldResult>();
       Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objName).getDescribe().fields.getMap();
       for(Schema.SobjectField sfield:fieldMap.values()){
            schema.DescribeFieldResult dfield=sfield.getDescribe();
            if(dField.isUpdateable()==true && !(dField.isAutoNumber() || dField.isCalculated()))
                fieldsDescribe.put(dfield.getName(),dfield);
        }
        return fieldsDescribe;

    }
    
    public map<string,object> getFieldsData(string objName){
        
        map<string,object> fieldsData=new map<string,object>();
        Set<Schema.DisplayType> stringTypes=new Set<Schema.DisplayType>();
        
        stringTypes.add(Schema.DisplayType.TextArea);
        stringTypes.add(Schema.DisplayType.String);
        stringTypes.add(Schema.DisplayType.Address);
        
        if(fieldsDescribe==null)
            fieldsDescribe=getFields(objName);
        
        
        for(string key:fieldsDescribe.keySet()){
         DescribeFieldResult dField=fieldsDescribe.get(key);
         double rand=Math.random();
         if(stringTypes.contains(dField.getType())==true){
            fieldsData.put(key,DataFactory.getTextData(dField.getLength()));
         }
         else if(dField.getType()==Schema.DisplayType.PICKLIST){
            fieldsData.put(key, DataFactory.getRandomPicklistValue(dField));
         }
         else{
             
             if(dField.getType()==Schema.DisplayType.DOUBLE){
                system.debug('key =>'+key+' val==>'+dField.getScale());    
             }
             
             if(dField.getType()==Schema.DisplayType.DOUBLE && dField.getScale()==0){
                fieldsData.put(key,DataFactory.getData(Schema.DisplayType.INTEGER));    
             }
             else{
                 fieldsData.put(key,DataFactory.getData(dField.getType()));    
             }
         }
        }
        return fieldsData;
    }
 
}