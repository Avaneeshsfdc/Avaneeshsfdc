@isTest(seealldata=true)
public class knowledgeArticleTest {
    static testMethod void validateKnowledgeArticle() {
        
        Test.startTest();
        Topic topic = new Topic(Name='My Random Test Topic');
        insert topic;
        
        Profile p = [SELECT Id,name FROM Profile where name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='testUserOrg@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='testUserOrg@Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuserHRSA@testorg.com', UserPermissionsKnowledgeUser=true);
        System.runAs(u){
            List<Knowledge__kav> kavList = [SELECT Id,Title,KnowledgeArticleId FROM Knowledge__kav];
            Knowledge__kav k = new Knowledge__kav(URLName ='KnowledgeURL1'+kavList.size(),title='Test'); 
            Insert k;
            Knowledge__kav obj1 = [SELECT Id,Title,KnowledgeArticleId FROM Knowledge__kav WHERE id =: k.Id];
            KbManagement.PublishingService.publishArticle(obj1.KnowledgeArticleId, true);
            List<KnowledgeArticleVersion> knowledgeAssignmentList = [SELECT Id, KnowledgeArticleId FROM 
                                                                     KnowledgeArticleVersion];
            
            ConnectAPI.Topics.assignTopic(null,String.valueOf(obj1.id),String.valueOf(topic.Id));
            KnowledgeArticle.getTopicData(topic.name);
            KnowledgeArticle.getTopicsData(topic.name);
        }
        Test.stopTest();
    }
}