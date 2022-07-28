public class contactRollUpTriggerHelper {
    /*
		@uthor : Avaneesh Singh
		@createdDate : 07-28-2022
		@Description : This method is calculating all contact which are inserted and deleted or update for an account
	*/
    public static void rollUpCountMethod(List<Contact> newList,List<Contact> oldList , Map<Id,Contact> oldMap){
         Map<Id,Account> accountToUpdate = new Map<Id,Account>(); // requried an account map to make it bulkfied 
       List<Contact> conList = trigger.isDelete ? oldList : newList; // checking the required list based on event fire by trigger
        for(contact con : conList){
            if(con.accountId != null && !accountToUpdate.containsKey(con.accountId)){ // handle all the senerio for insert update delete
                accountToUpdate.put(con.AccountId , new account(id=con.AccountId ,Count_Contacts__c=0));
            }
            // special case for account update
            if(trigger.isUpdate && con.AccountId != null && oldMap.get(con.Id).accountid != con.AccountId 
               && !accountToUpdate.containsKey(oldMap.get(con.Id).accountid)){
                accountToUpdate.put(oldMap.get(con.Id).accountid , new account(id=oldMap.get(con.Id).accountid ,Count_Contacts__c=0));
            }
        }
        
        if(!accountToUpdate.isEmpty()){
             // make an aggregate result to check the current no of contacts available
            for(AggregateResult arEach : [Select count(id) contactCounts,accountId from contact where accountid In :accountToUpdate.keySet()
                                          group by accountId]){
                id accountids = (Id)arEach.get('accountId');
                Decimal contactCount = (Decimal) arEach.get('contactCounts'); 
                Account accountInfo = accountToUpdate.get(accountIds);
                accountInfo.Count_Contacts__c = contactCount;
                accountToUpdate.put(accountIds,accountInfo);
            }
        }
        // update the contacts
       if(!accountToUpdate.isEmpty())
           update accountToUpdate.values();
    }
}