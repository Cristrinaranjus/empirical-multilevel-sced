options(renv.config.pak.enabled = TRUE) # Make {renv} use {pak}

options(pkgType = "binary") # Use binary versions of packages only to avoid
                            #   errors when restoring the environment, if a user
                            #   cannot build the source packages.

source("renv/activate.R")

require("pak", quietly = TRUE) # Avoids {renv} "inconsistent state" diagnostic
