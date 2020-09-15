resource "google_folder" "top_folder" {
  display_name = var.top_level_folder
  parent       = "organizations/**********"
}
