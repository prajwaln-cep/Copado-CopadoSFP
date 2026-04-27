public with sharing class GeneticController {
    /**
     * Returns Account for the given Id, or null if not found or if accountId is null.
     * Safe SOQL into a list to avoid "List has no rows for assignment to SObject" exceptions.
     */
    public static Account getAccountById(Id accountId) {
        if (accountId == null) return null;
        List<Account> accs = [
            SELECT Id, Name, Type, Industry
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];
        if (accs.isEmpty()) return null;
        return accs[0];
    }
}
