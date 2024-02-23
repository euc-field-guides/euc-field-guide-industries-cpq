Organization org = [SELECT Id, IsSandbox FROM Organization];
if (org.IsSandbox) {
  // Force use of permission set licenses for SFI
  // Source: https://help.salesforce.com/s/articleView?id=ind.comms_t_242_set_up_sandbox_environments_for_permission_set_licenses.htm&type=5
  vlocity_cmt.VlocityFeatureService.enablePSLOnlyCheck();
}

// force SFI to use the new Standard Object Model
// Source: https://help.salesforce.com/s/articleView?id=sf.os_migrate_change_the_sobject_data_model_after_migration.htm&type=5
vlocity_cmt.OmniStudioPostInstallClass.useStandardDataModel();

// Enable default set of features commonly used with Energy & Utilities
vlocity_cmt.VlocityFeatureService.enableUsageFeature();
vlocity_cmt.VlocityFeatureService.enableMLSFeature();
vlocity_cmt.VlocityFeatureService.enableCostAndMarginFeature();
vlocity_cmt.VlocityFeatureService.enableWorkSetFeature();
vlocity_cmt.VlocityFeatureService.enableV2AttributeModel();
