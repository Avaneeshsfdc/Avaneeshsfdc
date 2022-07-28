global without sharing class KnowledgeArticle {
    @AuraEnabled
    global static List<wrapperClass> getTopicData(String name){
        List<wrapperClass>  wrapperClassList = new List<wrapperClass> ();
    Topic topicinfo = [Select id , name from topic where name=:name limit 1 ];
        if(topicinfo != null){
           List<KnowledgeArticleVersion> knowledgeAssignmentList = [SELECT Id, KnowledgeArticleId FROM 
            KnowledgeArticleVersion WHERE Language = 'en_US' AND PublishStatus = 'Online' AND Id in 
            (SELECT EntityId FROM TopicAssignment WHERE TopicId = :topicinfo.id ) limit 500];
            system.debug('------'+[SELECT Id, KnowledgeArticleId,Language,PublishStatus FROM KnowledgeArticleVersion]);
            system.debug('------'+[Select id , name from topic]);
            system.debug('-->>'+[SELECT EntityId FROM TopicAssignment]);
            if(!knowledgeAssignmentList.isEmpty()){
                Set<Id> allKnowledgeArticleSet = new Set<Id>();
                for(KnowledgeArticleVersion kavs : knowledgeAssignmentList){
                    allKnowledgeArticleSet.add(kavs.KnowledgeArticleId);
                }
				if(!allKnowledgeArticleSet.isEmpty()){
                    List<Knowledge__kav> FAQList = [SELECT Id, Question__c,Answer__c FROM 
                                                Knowledge__kav where KnowledgeArticleId  IN :allKnowledgeArticleSet];
                        if(!FAQList.isEmpty()){
                            for(Knowledge__kav faq : FAQList){
                                WrapperClass wc = new WrapperClass(faq.Question__c , faq.Answer__c,faq.id);
                                wrapperClassList.add(wc);                              
                            }
                        }                     
                }
            }
        }
        return wrapperClassList;
    }
    @AuraEnabled(cacheable=true)
    global static List<topic> getTopicsData(String name){
        
        List<String> allTopicList = new List<String>();
        if(name != null & name == 'Any'){
            return [Select id , name from topic ];
            
        }else{
            return [Select id , name from topic where name =: name limit 1000];
        }        
    }
    
    global class wrapperClass{
        @AuraEnabled
        global String Question;
        @AuraEnabled
        global String Answers;
        @AuraEnabled
        global Id knowledgeId;
            global wrapperClass(String Question , String Answers,Id knowledgeId){
                this.Question = Question;
                this.Answers = Answers;
                this.knowledgeId = knowledgeId;
            }
    }


}