trigger contactRollUpTrigger on Contact (after insert, after update,after delete) {
	contactRollUpTriggerHelper.rollUpCountMethod(trigger.new,trigger.old,trigger.oldMap);
}