list.dirs(path = ".", full.names = TRUE, recursive = TRUE)

fls <- list.files(pattern='*.csv')
file.copy(fls,
          to = "new_directory", recursive = TRUE,
          overwrite = TRUE, copy.mode = TRUE, copy.date = FALSE)