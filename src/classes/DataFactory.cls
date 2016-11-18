/**
 * Author:Andres K. Tejada(andres.tejada27@gmail.com)
 * Description: Class to generate data of any kind in sfdc.
 **/
public class DataFactory {

    
   private static string text='Lorem ipsum dolor sit amet, consectetur adipiscing elit.'+
            'Aliquam commodo, velit vel consectetur cursus, '+
            'urna erat mattis ligula, nec ullamcorper massa '+
            'sem sit amet dui. Suspendisse nisi velit, '+
            'congue vitae lacus vel, eleifend maximus nisl. '+
            'Pellentesque imperdiet libero mattis est dignissim vestibulum.'+
            'Praesent quis euismod velit. Donec ac enim vitae lacus faucibus'+
            'suscipit non non magna. Vestibulum id augue sed lorem euismod semper. '+
            'Ut vulputate sollicitudin purus tristique lobortis. Proin in ante vel '+
            'justo ornare viverra. Integer auctor leo turpis, ac fringilla orci aliquam nec. '+
            'In felis sapien, elementum a accumsan sit amet, malesuada a ligula. '+
            'Nam sagittis, sapien ultrices malesuada tempus, felis leo lobortis orci, '+
            'quis venenatis urna mauris et lectus. Mauris id velit fermentum nulla '+
            'pulvinar malesuada.';
    
    public static string getTextData(integer length){
      
        
        if(text.length()>=length){
            return text.substring(0,length);
        }
        return '';
            
    }
    
    public static string getRandomPicklistValue(DescribeFieldResult fieldResult){
        list<Schema.Picklistentry> pickListVals=fieldResult.getPicklistValues();  
        integer size=pickListVals.size() -1;
        return pickListVals.get(getRandomInt(0,size)).getLabel();
    }
    
    public static Object getRandomItem(List<Object> objs){
        integer size=objs.size() -1;
        return objs.get(getRandomInt(0,size));
    }
    
    public static Integer getRandomInt(Integer lower, Integer upper){
        return Math.round(Math.random() * (upper - lower)) + lower;
    }
    
    public static Double getRandomDouble(Integer lower, Integer upper){
        return (Math.random() * (upper - lower)) + lower;
    }
    
    public static Double getRandomPercent(){
        return getRandomInt(1,10)/10;
    }
    
    public static String getRandomText(integer length){
        integer size=text.length()-1;
        if(length>size)
            return null;
        
        string newText=text.substring(getRandomInt(1,10),getRandomInt(50,size));
        return newText.mid(0, length).trim();
    }
    
    public static String getRandomEmail(){
        string randomEmail=getTextData(getRandomInt(6,10))+'@'+getTextData(getRandomInt(8,12)).trim()+'.com';
        return randomEmail.replace(' ', '');
    }
    
    public static List<Integer> getRandomIntN(Integer lower, Integer upper,Integer Qty){
        Set<Integer> rList=new Set<Integer>();
        Integer num=1;
        while(num<=qty){
            rList.add(getRandomInt(lower,upper));
            num +=1;
        }
        return new List<Integer>(rList);
    }
            
    public static List<Double> getRandomDoubleN(Integer lower, Integer upper,Integer Qty){
        Set<Double> rList=new Set<Double>();
        Integer num=1;
        while(num<=qty){
            rList.add(getRandomDouble(lower,upper));
            num +=1;
        }
        return new List<Double>(rList);
    }
    
    public static string getUniqueText(Integer length){
        return (getRandomInt(1,9)+getRandomText(length-4).trim() + getRandomInt(100,900)).trim().replace(' ','');
    }
    
    public static List<string> getUniqueTextN(integer length,integer qty){
        Set<String> rList=new Set<string>();
        Integer num=1;
        while(num<=qty){
            rList.add(getUniqueText(length).trim());
            num +=1;
        }
        return new List<String>(rList);
    }
    
    
    public static List<String> getRandomTextN(Integer length,Integer Qty){
        Set<String> rList=new Set<string>();
        Integer num=1;
        while(num<=qty){
            rList.add(getRandomText(length));
            num +=1;
        }
        return new List<String>(rList);
    }
    
    public static List<Date> getMonthDates(integer month){
        Date currentDate=Date.today();
        integer days=Date.daysInMonth(currentDate.year(),month);
        List<Date> dates=new List<Date>();
        integer count=1;
        //dates.add(Date.newInstance(currentDate.year(),month,count));
        do{
            dates.add(Date.newInstance(currentDate.year(),month,count));    
            count++;
        }
        while(count<=days);
        return dates;
    }
    
    public static List<Date> getDates(Date startDate,Date dueDate){
    
        List<Date> dates=new List<Date>();
        dates.add(startDate);
        Integer numberDaysDue = startDate.daysBetween(dueDate);
        integer count=1;
        dates.add(startDate);
        while(numberDaysDue>0 && count<=numberDaysDue){
            dates.add(startDate.addDays(count));
            count++;
        }
        return dates;
    }
    
    
    
    public static object getData(Schema.DisplayType displayType){
        
        map<Schema.DisplayType,object> defMapTypes=new map<Schema.DisplayType,object>();
        defMapTypes.put(Schema.DisplayType.Address,getRandomText(100));
        defMapTypes.put(Schema.DisplayType.Boolean,false);
        defMapTypes.put(Schema.DisplayType.Date,date.today());
        defMapTypes.put(Schema.DisplayType.DATETIME,DateTime.now());
        defMapTypes.put(Schema.DisplayType.EMAIL,getRandomEmail());
        defMapTypes.put(Schema.DisplayType.INTEGER,getRandomInt(1,100));
        defMapTypes.put(Schema.DisplayType.String,getRandomText(6));
        defMapTypes.put(Schema.DisplayType.Reference,null);
        defMapTypes.put(Schema.DisplayType.PERCENT,getRandomPercent());
        defMapTypes.put(Schema.DisplayType.DOUBLE,getRandomDouble(50,1850));
        defMapTypes.put(Schema.DisplayType.CURRENCY,getRandomDouble(1000,30850));
        defMapTypes.put(Schema.DisplayType.TextArea,getRandomText(50));
        defMapTypes.put(Schema.DisplayType.URL,'http://www.FIXT-THIS.com');
                
        if(defMapTypes.containsKey(displayType))
            return defMapTypes.get(displayType);
        
        return null;
    }
    
    public static List<Id> getListIds(List<SObject> objs){
        List<Id> ids=new List<Id>();
        for(SObject obj:objs){
            ids.add((Id)obj.get('Id'));
        }
        return ids;
    }
    
    public static List<Object> getListValues(List<SObject> objs,string fieldName){
        List<Object> ids=new List<Object>();
        for(SObject obj:objs){
            ids.add(obj.get(fieldName));
        }
        return ids;
    }
    
}
