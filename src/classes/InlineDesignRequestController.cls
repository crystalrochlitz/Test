public with sharing class InlineDesignRequestController {

	private final Opportunity record;
    List<Site_Information_Form__c> siteList {
        get {
            if(siteList == null) {
                siteList = new List<Site_Information_Form__c>();
            }
            return siteList;
        }
        set;
    }
    public Map<Id, List<Design__c>> siteToDesignMap {get;set;}

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public InlineDesignRequestController(ApexPages.StandardController stdController) {
        this.record = (Opportunity)stdController.getRecord();
        siteToDesignMap = new Map<Id, List<Design__c>>();

        for(Opportunity o : [SELECT Id, 
                                    (SELECT Id, Name, Site_Address__c  
                                     FROM R00N30000000t6dPEAQ__r) 
                             FROM Opportunity WHERE Id =: record.Id LIMIT 1]) {
            System.debug('o: ' + o);
            Set<Id> siteIds = new Set<Id>();
            for(Site_Information_Form__c s : o.R00N30000000t6dPEAQ__r) {
                siteToDesignMap.put(s.Id, new List<Design__c>());
            }
        }

        for(Design__c d : [SELECT Id, Status__c, Site__c 
                           FROM Design__c
                           WHERE Site__c IN: siteToDesignMap.keyset()]) {
            siteToDesignMap.get(d.Site__c).add(d);
        }
    } //End Constructor

    
}