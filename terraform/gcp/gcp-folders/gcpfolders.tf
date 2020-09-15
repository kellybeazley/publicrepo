module "gcp-folder" {
  source           = "../modules/gcp-folders"
  top_level_folder = "Folder1"
}

module "gcp-folder2" {
  source           = "../modules/gcp-folders"
  top_level_folder = "Folder2"
}

module "gcp-folder3" {
  source           = "../modules/gcp-folders"
  top_level_folder = "Folder3"
}
