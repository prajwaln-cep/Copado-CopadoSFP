@isTest
private class FirstApexAgentZeroTest {
    @isTest static void testGetAllAccounts() {
        // Arrange: create test accounts
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < 3; i++) accts.add(new Account(Name = 'TestAcct-' + i));
        insert accts;

        // Act
        Test.startTest();
        List<Account> results = FirstApexAgentZero.getAllAccounts();
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, results, 'Results should not be null');
        System.assert(results.size() >= 3, 'Expected at least the inserted test accounts to be returned');
    }
}
