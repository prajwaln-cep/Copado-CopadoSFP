public class ServiceProviderUtil {
    
    public static String getAccounts() {
        
        String accList;
		List<Account> accarrayList = [SELECT Id,Name FROM ACCOUNT LIMIT 10];
		accList = JSON.serialize(accarrayList);
		return accList;
    }

}