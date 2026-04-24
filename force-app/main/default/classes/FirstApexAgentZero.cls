public with sharing class FirstApexAgentZero {
    /**
     * Returns a list of Account records.
     * Adjust the SOQL fields and filters as needed.
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAllAccounts() {
        try {
            return [SELECT Id, Name FROM Account LIMIT 200];
        } catch (Exception e) {
            // Log and rethrow as appropriate for your org's logging framework
            throw new AuraHandledException('Error fetching accounts: ' + e.getMessage());
        }
    }
}
