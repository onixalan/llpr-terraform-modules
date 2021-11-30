resource "google_monitoring_notification_channel" "notification_channel" {
  project      = var.project_id
  display_name = var.notification_channel_name
  type         = "email"
  labels = {
    email_address = var.email_address
  }
}
resource "google_logging_metric" "logging_metric_Custom_Role_Changes" {
  project     = var.project_id
  name        = "CustomRoleChanges/metric"
  description = "Logs Custom Role Changes (Create/Delete/Update)"
  filter      = "resource.type=\"iam_role\" AND protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\" google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Custom Role Changes"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_custom_role" {
  project               = var.project_id
  display_name          = "Custom Role Changes Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "Custom Role Changes Monitoring [SUM]"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/CustomRoleChanges/metric\" AND resource.type=\"global\""
      duration   = "600s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "600s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [google_logging_metric.logging_metric_Custom_Role_Changes]
}

resource "google_logging_metric" "logging_metric_Project_IAM_Changes" {
  project     = var.project_id
  name        = "ProjectIAMChanges/metric"
  description = "Logs Project Changes - Addition or Removal of Owners"
  filter      = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Project IAM Changes"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_project_iam_changes" {
  project               = var.project_id
  display_name          = "Project IAM Changes Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "Project IAM Changes Monitoring [SUM]"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/ProjectIAMChanges/metric\" AND resource.type=\"global\""
      duration   = "600s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "600s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [google_logging_metric.logging_metric_Project_IAM_Changes]
}

resource "google_logging_metric" "logging_metric_SQL_Configuration_Changes" {
  project     = var.project_id
  name        = "SQLConfigurationChanges/metric"
  description = "Logs SQL Configuration Changes"
  filter      = "protoPayload.methodName=\"cloudsql.instances.update\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "SQL Configuration Changes"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_sql_config_changes" {
  project               = var.project_id
  display_name          = "SQL Configuration Changes Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "SQL Configuration Changes Monitoring [SUM]"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/SQLConfigurationChanges/metric\" AND resource.type=\"global\""
      duration   = "600s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "600s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [google_logging_metric.logging_metric_SQL_Configuration_Changes]
}
resource "google_logging_metric" "logging_metric_Storage_Permission_Changes" {
  project     = var.project_id
  name        = "StoragePermissionChanges/metric"
  description = "Logs Storage Permission Changes"
  filter      = "resource.type=gcs_bucket AND protoPayload.methodName=\"storage.setIamPermissions\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Storage Permission Changes"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_storage_permission_changes" {
  project               = var.project_id
  display_name          = "Storage Permission Changes Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "Storage Permission Changes Monitoring [SUM]"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/StoragePermissionChanges/metric\" AND resource.type=\"global\""
      duration   = "600s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "600s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [google_logging_metric.logging_metric_Storage_Permission_Changes]
}

resource "google_logging_metric" "logging_metric_VPC_Firewall_Rule_Changes" {
  project     = var.project_id
  name        = "VPCFirewallRuleChanges/metric"
  description = "Logs VPC Firewall Rule Changes"
  filter      = "resource.type=\"gce_firewall_rule\" AND jsonPayload.event_subtype=\"compute.firewalls.patch\" OR jsonPayload.event_subtype=\"compute.firewalls.insert\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "VPC Firewall Rule Changes"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_vpc_firewall_rule_changes" {
  project               = var.project_id
  display_name          = "VPC Firewall Rule Changes Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "VPC Firewall Rule Changes Monitoring [SUM]"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/VPCFirewallRuleChanges/metric\" AND resource.type=\"global\""
      duration   = "600s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "600s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [google_logging_metric.logging_metric_VPC_Firewall_Rule_Changes]
}

resource "google_logging_metric" "logging_metric_VPC_Network_Changes" {
  project     = var.project_id
  name        = "VPCNetworkChanges/metric"
  description = "Logs VPC Network Changes - Insert/Patch/Delete/Peering"
  filter      = "resource.type=gce_network AND jsonPayload.event_subtype=\"compute.networks.insert\" OR jsonPayload.event_subtype=\"compute.networks.patch\" OR jsonPayload.event_subtype=\"compute.networks.delete\" OR jsonPayload.event_subtype=\"compute.networks.removePeering\" OR jsonPayload.event_subtype=\"compute.networks.addPeering\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "VPC Network Changes Changes"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_vpc_network_changes" {
  project               = var.project_id
  display_name          = "VPC Network Changes Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "VPC Network Changes Monitoring [SUM]"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/VPCNetworkChanges/metric\" AND resource.type=\"global\""
      duration   = "600s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "600s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [google_logging_metric.logging_metric_VPC_Network_Changes]
}

resource "google_logging_metric" "logging_metric_VPC_Network_Route_Changes" {
  project     = var.project_id
  name        = "VPCNetworkRouteChanges/metric"
  description = "Logs VPC Network Route Changes"
  filter      = "resource.type=\"gce_route\" AND jsonPayload.event_subtype=\"compute.routes.delete\" OR jsonPayload.event_subtype=\"compute.routes.insert\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "VPC Network Route Changes"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_vpc_network_route_changes" {
  project               = var.project_id
  display_name          = "VPC Network Route Changes Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "VPC Network Route Changes Monitoring [SUM]"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/VPCNetworkRouteChanges/metric\" AND resource.type=\"global\""
      duration   = "600s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "600s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [google_logging_metric.logging_metric_VPC_Network_Route_Changes]
}
