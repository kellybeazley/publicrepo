module "gcp-project" {
  source          = ".//modules/project-creation"
  project_name    = "project_name"
  billing_account = "*************"
  gcp_project_id  = "project-"
  # PROJECT TAGS -----------------------------------------------------------------------------------------------
  # Only hyphens (-), underscores (_), lowercase characters and numbers are allowed. International characters are allowed.
  env             = "prod"
  costcentre      = "********"
  cost_desc       = "***********"
  rev_gen         = "true"
  owner           = "kel-b"
  age_limit       = "4-years"
  team            = "kelly-team"
  #-------------------------------------------------------------------------------------------------------------
  folder_id       = "folder_id here"
  user_email      = ["kelly@****.com"]
  activate_apis   = ["compute.googleapis.com", "container.googleapis.com", "vpcaccess.googleapis.com"]
  budget          = "100000"
}
