resource "google_storage_bucket" "frontend" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}

resource "google_storage_bucket_iam_member" "public" {
  bucket = google_storage_bucket.frontend.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
