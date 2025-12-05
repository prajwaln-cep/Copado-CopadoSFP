public class ServiceProviderUtil {
    
    public static List<Account> getAccounts() {
        
        String accList;
		List<Account> accarrayList = [SELECT Id,Name FROM ACCOUNT LIMIT 10];
		accList = JSON.serialize(accarrayList);
		return accarrayList;
    }

     public static List<Account> getAccountsDetails() {
        String accList;
		List<Account> accarrayList = [SELECT Id,Name FROM ACCOUNT LIMIT 10];
		accList = JSON.serialize(accarrayList);
		return accarrayList;
    }
    
    

}