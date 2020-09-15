resource "random_id" "project" {
  byte_length = 4
  prefix      = var.gcp_project_id
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = random_id.project.hex
  billing_account = var.billing_account
  folder_id       = var.folder_id
  labels = tomap({ "env" = var.env,
    "costcentre" = var.costcentre,
    "cost_desc"  = var.cost_desc,
    "team"       = var.team,
    "rev_gen"    = var.rev_gen,
    "owner"      = var.owner,
    "age_limit"  = var.age_limit,
  })
}


resource "google_project_service" "activate_apis" {
  project                    = random_id.project.hex
  disable_dependent_services = true
  count                      = length(var.activate_apis)
  service                    = element(var.activate_apis, count.index)

  depends_on = [
    google_project.project,
  ]
}


resource "google_project_service" "billingapi" {
  project = random_id.project.hex
  service = "cloudbilling.googleapis.com"

  depends_on = [
    google_project.project,
  ]

}
resource "google_project_service" "budgetapi" {
  project = random_id.project.hex
  service = "billingbudgets.googleapis.com"

  depends_on = [
    google_project_service.billingapi,
  ]

}

output "project_id" {
  value = "google_project.project.project_id"
}

resource "google_project_iam_binding" "project" {
  project = random_id.project.hex
  role    = "roles/owner"
  members = formatlist("user:%s", var.user_email)

  depends_on = [
    google_project_service.activate_apis,
  ]
}

resource "google_billing_budget" "budget" {
  provider        = google-beta
  billing_account = var.billing_account
  display_name    = random_id.project.hex

  budget_filter {
    projects               = ["projects/${random_id.project.hex}"]
    credit_types_treatment = "EXCLUDE_ALL_CREDITS"
  }

  amount {
    specified_amount {
      currency_code = "EUR"
      units         = var.budget
    }
  }

  threshold_rules {
    threshold_percent = 0.5
  }

  threshold_rules {
    threshold_percent = 1.0
  }
  threshold_rules {
    threshold_percent = 0.9
    spend_basis       = "FORECASTED_SPEND"
  }


  depends_on = [
    google_project_service.budgetapi,
  ]
}
