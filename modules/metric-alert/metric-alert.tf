# NOTIFICATION CHANNEL
resource "google_monitoring_notification_channel" "notification_channel" {
  project      = var.project_id
  display_name = var.notification_channel_name
  type         = "email"
  labels = {
    email_address = var.email_address
  }
}

# LOG MONITORING / ALERTS 
resource "google_logging_metric" "log_metric_route" {
  project = var.project_id
  name    = "route_monitoring/metric"
  filter  = "resource.type=\"gce_route\" AND jsonPayload.event_subtype=\"compute.routes.delete\" OR jsonPayload.event_subtype=\"compute.routes.insert\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Route Monitoring"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_route" {
  project               = var.project_id
  display_name          = "Route Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "logging/user/ROUTE_MONITORING"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/route_monitoring/metric\" AND resource.type=\"global\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [
    google_logging_metric.log_metric_route,
  ]
}

resource "google_logging_metric" "log_metric_sql_instance" {
  project = var.project_id
  name    = "sql_instance_monitoring/metric"
  filter  = "protoPayload.methodName=\"cloudsql.instances.update\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "SQL Instance Monitoring"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_sql_instance" {
  project               = var.project_id
  display_name          = "SQL Instance Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "logging/user/SQL_INSTANCE_MONITORING"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/sql_instance_monitoring/metric\" AND resource.type=\"global\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [
    google_logging_metric.log_metric_sql_instance,
  ]
}

resource "google_logging_metric" "log_metric_network" {
  project = var.project_id
  name    = "network_monitoring/metric"
  filter  = "resource.type=gce_network AND jsonPayload.event_subtype=\"compute.networks.insert\" OR jsonPayload.event_subtype=\"compute.networks.patch\" OR jsonPayload.event_subtype=\"compute.networks.delete\" OR jsonPayload.event_subtype=\"compute.networks.removePeering\" OR jsonPayload.event_subtype=\"compute.networks.addPeering\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Network Monitoring"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_network" {
  project               = var.project_id
  display_name          = "Network Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "logging/user/NETWORK_MONITORING"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/network_monitoring/metric\" AND resource.type=\"global\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [
    google_logging_metric.log_metric_network,
  ]
}

resource "google_logging_metric" "log_metric_firewall" {
  project = var.project_id
  name    = "firewall_monitoring/metric"
  filter  = "resource.type=\"gce_firewall_rule\" AND jsonPayload.event_subtype=\"compute.firewalls.patch\" OR jsonPayload.event_subtype=\"compute.firewalls.insert\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Firewall Monitoring"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_firewall" {
  project               = var.project_id
  display_name          = "Firewall Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "logging/user/FIREWALL_MONITORING"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/firewall_monitoring/metric\" AND resource.type=\"global\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [
    google_logging_metric.log_metric_firewall,
  ]
}

resource "google_logging_metric" "log_metric_project_ownership" {
  project = var.project_id
  name    = "project_ownership_monitoring/metric"
  filter  = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Project Ownership Monitoring"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_project_ownership" {
  project               = var.project_id
  display_name          = "Project Ownership Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "logging/user/PROJECT_OWNERSHIP_MONITORING"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/project_ownership_monitoring/metric\" AND resource.type=\"global\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [
    google_logging_metric.log_metric_project_ownership,
  ]
}

resource "google_logging_metric" "log_metric_bucket_iam" {
  project = var.project_id
  name    = "bucket_iam_monitoring/metric"
  filter  = "resource.type=gcs_bucket AND protoPayload.methodName=\"storage.setIamPermissions\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Bucket IAM Monitoring"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_bucket_iam" {
  project               = var.project_id
  display_name          = "Bucket IAM Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "logging/user/BUCKET_IAM_MONITORING"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/bucket_iam_monitoring/metric\" AND resource.type=\"global\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [
    google_logging_metric.log_metric_bucket_iam,
  ]
}

resource "google_logging_metric" "log_metric_audit_config" {
  project = var.project_id
  name    = "audit_config_monitoring/metric"
  filter  = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Audit Config Monitoring"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_audit_config" {
  project               = var.project_id
  display_name          = "Audit Config Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "logging/user/AUDIT_CONFIG_MONITORING"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/audit_config_monitoring/metric\" AND resource.type=\"global\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [
    google_logging_metric.log_metric_audit_config,
  ]
}

resource "google_logging_metric" "log_metric_custom_role" {
  project = var.project_id
  name    = "custom_role_monitoring/metric"
  filter  = "resource.type=\"iam_role\" AND protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Custom Role Monitoring"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_custom_role" {
  project               = var.project_id
  display_name          = "Custom Role Monitoring"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.notification_channel.name]
  conditions {
    display_name = "logging/user/CUSTOM_ROLE_MONITORING"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/custom_role_monitoring/metric\" AND resource.type=\"global\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  depends_on = [
    google_logging_metric.log_metric_custom_role,
  ]
}
