variable "gcp_project_id" {
  description = "random project id created"
  default     = "snproject-"
}

variable "billing_account" {}


variable "region" {
  description = "GCP Region"
  default     = "europe-west4"
}


variable "project_name" {
  description = "project name to be created"
}


variable "activate_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
}

variable "user_email" {
  description = "user to add to gcp project"
  type        = list(string)
}

variable "folder_id" {
  description = "folder_id for project to be placed in"
}

variable "budget" {
  description = "Budget rounded to the nearest €"
  type        = string
}

#PROJECT TAGS --------------------------------------------------------------------------------------------

variable "env" {
  description = "Map of labels for project"
  type        = string
}


variable "costcentre" {
  description = "Map of labels for project"
  type        = string
}


variable "cost_desc" {
  description = "Map of labels for project"
  type        = string
}


variable "rev_gen" {
  description = "Map of labels for project"
  type        = string
}


variable "owner" {
  description = "Map of labels for project"
  type        = string
}


variable "age_limit" {
  description = "Map of labels for project"
  type        = string
}

variable "team" {
  description = "Map of labels for project"
  type        = string
}
