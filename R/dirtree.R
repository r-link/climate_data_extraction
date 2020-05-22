# simple script for RDWD directory tree based on this gist by Jenny Bryan: https://gist.github.com/jennybc/2bf1dbe6eb1f261dfe60

dirtree <- function(files, level = Inf, max_files = 3, indent = 2) {
  # split directories
  files_split_up <- strsplit(files, "/")
  # trim directories to desired depth
  files_trimmed <- map(files_split_up, function(x) x[1:min(level, length(x))])
  # remove duplicate entries arising after trimming
  files_trimmed[duplicated(files_trimmed)] <- NULL
  
  # get true number of levels
  nlevels <- min(level, max(sapply(files_trimmed, length)))
  
  # get file folder hierarchy and prepare for plotting
  hierarchy <- vector(mode = "list", length = nlevels)
  for (i in 1:nlevels){
    hierarchy[[i]] <- map_chr(files_trimmed, ~.x[i])
    if(i == 1) pad <-"" else pad <- paste0(paste(rep(" ", (i-1) * indent), collapse = ""), "|__")
    hierarchy[[i]]<- paste0(pad, hierarchy[[i]])
  }
  
  # rearrange output, remove extra files and reshape
  suppressMessages(
    out <- bind_cols(hierarchy) %>% 
      group_by_at(vars(!contains(as.character(nlevels)))) %>% 
      top_n(n = max_files) %>% 
      ungroup %>% 
      mutate_all(~paste0(.x, "\n")) %>% 
      mutate_at(vars(!contains(as.character(nlevels))), ~ifelse(duplicated(.x), NA, .x)) %>% 
      mutate(ID = 1:nrow(.)) %>% 
      gather(key, value, -ID) %>% 
      arrange(ID, key) %>% 
      filter(!is.na(value),
             !grepl("__NA", value))
  )
  # print output
  cat(out$value, sep = "\n")
}
