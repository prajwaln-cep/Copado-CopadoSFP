@isTest
private class GeneticControllerTest {

    @isTest static void testGetAccountByIdFound() {
        // create test account
        Account a = new Account(Name='Test Account', Type='Prospect', Industry='Technology');
        insert a;

        Test.startTest();
        Account result = GeneticController.getAccountById(a.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Account should be returned');
        System.assertEquals(a.Id, result.Id);
        System.assertEquals('Test Account', result.Name);
    }

    @isTest static void testGetAccountByIdNotFound() {
        // use a syntactically valid Id that does not exist
        Id fakeId = Id.valueOf('001000000000000AAA');

        Test.startTest();
        Account result = GeneticController.getAccountById(fakeId);
        Test.stopTest();

        System.assertEquals(null, result, 'Should return null for non-existent id');
    }

    @isTest static void testGetAccountByIdNull() {
        Test.startTest();
        Account result = GeneticController.getAccountById(null);
        Test.stopTest();

        System.assertEquals(null, result, 'Should return null for null input');
    }
}
