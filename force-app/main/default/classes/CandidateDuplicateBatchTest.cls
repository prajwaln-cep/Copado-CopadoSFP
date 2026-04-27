@isTest
private class CandidateDuplicateBatchTest {

    @isTest static void testDuplicateDetectionByEmailPhoneExternalId() {
        // Create a master then a duplicate (same Email/Phone/ExternalId) and a unique record
        Candidate__c master = new Candidate__c(Name = 'Master Candidate', Email__c = 'dup@example.com', Phone__c = '1112223333', External_Id__c = 'EXT-1');
        insert master;

        Candidate__c dup = new Candidate__c(Name = 'Duplicate Candidate', Email__c = 'dup@example.com', Phone__c = '1112223333', External_Id__c = 'EXT-1');
        Candidate__c uniqueRec = new Candidate__c(Name = 'Unique Candidate', Email__c = 'unique@example.com', Phone__c = '9998887777');
        insert new List<Candidate__c>{ dup, uniqueRec };

        Test.startTest();
        CandidateDuplicateBatch batch = new CandidateDuplicateBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        master = [SELECT Id, Duplicate__c, Duplicate_Of__c FROM Candidate__c WHERE Id = :master.Id];
        dup = [SELECT Id, Duplicate__c, Duplicate_Of__c FROM Candidate__c WHERE Id = :dup.Id];
        uniqueRec = [SELECT Id, Duplicate__c, Duplicate_Of__c FROM Candidate__c WHERE Id = :uniqueRec.Id];

        System.assertEquals(false, master.Duplicate__c, 'Master should not be marked duplicate');
        System.assertEquals(true, dup.Duplicate__c, 'Duplicate should be marked');
        System.assertEquals(master.Id, dup.Duplicate_Of__c, 'Duplicate_Of__c must point to master');
        System.assertEquals(false, uniqueRec.Duplicate__c, 'Unique record should not be marked');
    }

    @isTest static void testNoDuplicatesLeavesRecordsUntouched() {
        // Create several distinct candidates and verify none are marked
        List<Candidate__c> list = new List<Candidate__c>();
        for (Integer i = 0; i < 5; i++) {
            list.add(new Candidate__c(Name = 'Unique' + i, Email__c = 'u' + i + '@example.com', Phone__c = '555000' + i));
        }
        insert list;

        Test.startTest();
        Database.executeBatch(new CandidateDuplicateBatch(), 200);
        Test.stopTest();

        List<Candidate__c> results = [SELECT Id, Duplicate__c FROM Candidate__c WHERE Id IN :list];
        for (Candidate__c c : results) {
            System.assertEquals(false, c.Duplicate__c, 'Records with no duplicates should remain unmarked');
        }
    }

    @isTest static void testBulkProcessingMarksAllButOneMaster() {
        // Bulk scenario: create many records with the same Email to force batching
        List<Candidate__c> bulk = new List<Candidate__c>();
        Integer total = 600; // greater than one batch size to exercise multiple execute() calls
        for (Integer i = 0; i < total; i++) {
            bulk.add(new Candidate__c(Name = 'Bulk' + i, Email__c = 'bulk@example.com', Phone__c = '2000000' + i));
        }
        insert bulk;

        Test.startTest();
        Database.executeBatch(new CandidateDuplicateBatch(), 200);
        Test.stopTest();

        // One master should remain unmarked; all others should be marked
        List<Candidate__c> grouped = [SELECT Id, Duplicate__c FROM Candidate__c WHERE Email__c = 'bulk@example.com' ORDER BY CreatedDate ASC];
        System.assertEquals(total, grouped.size(), 'Expected all inserted records');

        Integer markedCount = 0;
        for (Candidate__c c : grouped) {
            if (c.Duplicate__c == true) markedCount++;
        }
        System.assertEquals(total - 1, markedCount, 'All but one record should be marked as duplicate');
    }
}
