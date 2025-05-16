#' Validate taxonomy using World Register of Marine Species (WoRMS)
#'
#' The aim of a World Register of Marine Species (WoRMS) is to provide an
#' authoritative and comprehensive list of names of marine organisms, including
#' information on synonymy. While the highest priority goes to valid names,
#' other names in use are included so that this register can serve as a guide to
#' interpret taxonomic literature.
#'
#' The content of WoRMS is controlled by taxonomic and thematic experts, not by
#' database managers. WoRMS has an editorial management system where each
#' taxonomic group is represented by an expert who has the authority over the
#' content, and is responsible for controlling the quality of the information.
#' Each of these main taxonomic editors can invite several specialists of
#' smaller groups within their area of responsibility to join them.
#'
#' This register of marine species grew out of the European Register of Marine
#' Species (ERMS), and its combination with several other species registers
#' maintained at the Flanders Marine Institute (VLIZ). Rather than building
#' separate registers for all projects, and to make sure taxonomy used in these
#' different projects is consistent, VLIZ developed a consolidated database
#' called ‘Aphia’. A list of marine species registers included in Aphia is
#' available here. MarineSpecies.org is the web interface for the marine taxa
#' available in this Aphia database. WoRMS combines information from Aphia with
#' other authoritative marine species lists which are maintained by others (e.g.
#' AlgaeBase, FishBase), the so-called 'externally hosted and managed species
#' databases'.
#'
#' Resources to build MarineSpecies.org and Aphia were provided mainly by the EU
#' Network of Excellence ‘Marine Biodiversity and Ecosystem Functioning’
#' (MarBEF), and also by the EU funded Species 2000 Europe and ERMS projects.
#'
#' Aphia contains valid species names, synonyms and vernacular names, and extra
#' information such as literature and biogeographic data. Besides species names,
#' Aphia also contains the higher classification in which each scientific name
#' is linked to its parent taxon. The classification used is a ‘compromise’
#' between established systems and recent changes. Its aim is to aid data
#' management, rather than suggest any taxonomic or phylogenetic opinion on
#' species relationships.
#'
#' More information can be found at: https://www.marinespecies.org/about.php
#'
#' @param names A vector of species (or other) names
#'
#' @returns
#' @export
#'
#' @examples
#' mme_validateTaxonomy(names = c("Jasus edwardsii", "Calanus finmarchicus"))
#'
mme_validateTaxonomy <- function(spnames) {
  # Create a data frame and do some preliminary cleaning for species we know are incorrect but through experience
  # tend to cause issues with the worrms API. This is a bit of a hack but it works.

  dat <- data.frame(Name = spnames) %>%
    dplyr::mutate(
      Name = stringr::str_replace(Name, pattern = "Arripis georgianus", replacement = "Arripis georgiana"),
      Name = stringr::str_replace(Name, pattern = "Aspitrigla cuculus", replacement = "Chelidonichthys cuculus"),
      Name = stringr::str_replace(Name, pattern = "Atlantic herring", replacement = "Clupea harengus"),
      Name = stringr::str_replace(Name, pattern = "Auxis rochei rochei", replacement = "Auxis rochei"),
      Name = stringr::str_replace(Name, pattern = "Auxis thazard thazard", replacement = "Auxis thazard"),
      Name = stringr::str_replace(Name, pattern = "Cancer antennarius", replacement = "Romaleon antennarium"),
      Name = stringr::str_replace(Name, pattern = "Charybdis feriatus", replacement = "Charybdis (Charybdis) feriata"),
      Name = stringr::str_replace(Name, pattern = "Cheilodactylus variegatus", replacement = "Chirodactylus variegatus"),
      Name = stringr::str_replace(Name, pattern = "Chione stutchburyi", replacement = "Austrovenus stutchburyi"),
      Name = stringr::str_replace(Name, pattern = "Chlamys delicatula", replacement = "Zygochlamys delicatula"),
      Name = stringr::str_replace(Name, pattern = "Chondrichthyes", replacement = "Elasmobranchii"),
      Name = stringr::str_replace(Name, pattern = "Crassostrea gigas", replacement = "Magallana gigas"),
      Name = stringr::str_replace(Name, pattern = "Echinaster sentus", replacement = "Echinaster (Othilia) sentus"),
      Name = stringr::str_replace(Name, pattern = "Emmelichthys nitidus nitidus", replacement = "Emmelichthys nitidus"),
      Name = stringr::str_replace(Name, pattern = "Goatfishes", replacement = "Mullidae"),
      Name = stringr::str_replace(Name, pattern = "Grenadiers, rattails", replacement = "Macrourinae"),
      Name = stringr::str_replace(Name, pattern = "Helicolenus dactylopterus dactylopterus", replacement = "Helicolenus dactylopterus"),
      Name = stringr::str_replace(Name, pattern = "Holothuria atra", replacement = "Holothuria (Halodeima) atra"),
      Name = stringr::str_replace(Name, pattern = "Holothuria edulis", replacement = "Holothuria (Halodeima) edulis"),
      Name = stringr::str_replace(Name, pattern = "Holothuria floridana", replacement = "Holothuria (Halodeima) floridana"),
      Name = stringr::str_replace(Name, pattern = "Inermiidae", replacement = "Haemulinae"),
      Name = stringr::str_replace(Name, pattern = "Jacquinotia edwardsi", replacement = "Jacquinotia edwardsii"),
      Name = stringr::str_replace(Name, pattern = "Jasus verreauxi", replacement = "Sagmariasus verreauxi"),
      Name = stringr::str_replace(Name, pattern = "Large yellow croaker", replacement = "Larimichthys crocea"),
      Name = stringr::str_replace(Name, pattern = "Lemon sole", replacement = "Microstomus kitt"),
      Name = stringr::str_replace(Name, pattern = "Lithodes antarcticus", replacement = "Lithodes santolla"),
      Name = stringr::str_replace(Name, pattern = "Lithodes antarcticus", replacement = "Lithodes santolla"),
      Name = stringr::str_replace(Name, pattern = "Makaira indica", replacement = "Istiompax indica"),
      Name = stringr::str_replace(Name, pattern = "Megabalanus psittacus", replacement = "Austromegabalanus psittacus"),
      Name = stringr::str_replace(Name, pattern = "Merluccius gayi gayi", replacement = "Merluccius gayi"),
      Name = stringr::str_replace(Name, pattern = "Mytiloida", replacement = "Mytilida"),
      Name = stringr::str_replace(Name, pattern = "Oncorhynchus masou masou", replacement = "Oncorhynchus masou"),
      Name = stringr::str_replace(Name, pattern = "Osmerus mordax mordax", replacement = "Osmerus mordax"),
      Name = stringr::str_replace(Name, pattern = "Panopea abrupta", replacement = "Panopea generosa"), # Original is extinct. I think is what is supposed to be. Misidentification occurred in 80s/90s.
      Name = stringr::str_replace(Name, pattern = "Pleuronectoidei", replacement = "Pleuronectiformes"),
      Name = stringr::str_replace(Name, pattern = "Pterothrissus belloci", replacement = "Nemoossis belloci"),
      Name = stringr::str_replace(Name, pattern = "Ray-finned fishes", replacement = "Actinopterygii"),
      Name = stringr::str_replace(Name, pattern = "Rhinobatos percellens", replacement = "Pseudobatos percellens"),
      Name = stringr::str_replace(Name, pattern = "Rhinobatos planiceps", replacement = "Pseudobatos planiceps"),
      Name = stringr::str_replace(Name, pattern = "Rough whip stingrays", replacement = "Dasyatis"),
      Name = stringr::str_replace(Name, pattern = "Salmo trutta trutta", replacement = "Salmo trutta"),
      Name = stringr::str_replace(Name, pattern = "Salvelinus alpinus alpinus", replacement = "Salvelinus alpinus"),
      Name = stringr::str_replace(Name, pattern = "Sarda chiliensis chiliensis", replacement = "Sarda chiliensis"),
      Name = stringr::str_replace(Name, pattern = "Scorpaeniformes", replacement = "Scorpaenoidei"),
      Name = stringr::str_replace(Name, pattern = "Sichel", replacement = "Pelecus cultratus"),
      Name = stringr::str_replace(Name, pattern = "Tetrapturus albidus", replacement = "Kajikia albida"),
      Name = stringr::str_replace(Name, pattern = "Tetrapturus audax", replacement = "Kajikia audax"),
      Name = stringr::str_replace(Name, pattern = "Teuthida", replacement = "Oegopsida"), # Squid sub/orders rearranged
      Name = stringr::str_replace(Name, pattern = "Theragra chalcogramma", replacement = "Gadus chalcogrammus"),
      Name = stringr::str_replace(Name, pattern = "Venus \\(\\=Chamelea\\) gallina", replacement = "Chamelea gallina"),
      Name = stringr::str_replace(Name, pattern = "Zidona dufresnei", replacement = "Zidona dufresnii"),
      Name = stringr::str_replace(Name, pattern = "Macroramphosidae", replacement = "Macroramphosinae"),
    ) %>%
    dplyr::filter(!Name %in% "Gadus ogac") # This is a synonym for Gadus macrocephalus
  # dplyr::mutate(CommonName = stringr::str_replace(CommonName, pattern = "Pacific cod", replacement = "Pacific and Greenland cod")) # Need to merge to avoid duplicates


  # Get the data from WoRMS -------------------------------------------------

  # Create a list of data frames to query the API in chunks of 100
  dat2 <- dat %>%
    dplyr::mutate(groupID = ceiling(dplyr::row_number() / 50)) %>%
    dplyr::group_split(.by = groupID)

  pb <- txtProgressBar(min = 0, max = nrow(dat), initial = 1, style = 3) # Initial progress bar

  # Do the first one to initiate the list
  templist <- worrms::wm_records_taxamatch(dat2[[1]]$Name)

  for (i in 2:length(dat2)) {
    templist <- c(templist, worrms::wm_records_taxamatch(dat2[[i]]$Name))
    setTxtProgressBar(pb, i) # Update progress bar
  }
  close(pb) # Close progress bar

  # templist - 107713
  templist2 <- bind_rows(templist)




  pb <- txtProgressBar(min = 0, max = nrow(dat), initial = 1, style = 3) # Initial progress bar
  templist <- bind_rows(worrms::wm_records_taxamatch(dat$Name[1]))

  templist_saved <- templist



  # THIS IS THE ONE THAT IS WORKING - FRIDAY 14th MARCH 2025

  # Preallocate
  templist <- dplyr::bind_rows(worrms::wm_records_names("Jasus edwardsii", marine_only = FALSE, fuzzy = FALSE)) # Make sure the columns are of the right type. Then overwrite below.
  templist[1,] <- NA
  templist[1:nrow(dat),] <- templist[1,]

  for (i in 1:nrow(dat)) {
    tryCatch({
      wm <- bind_rows(worrms::wm_records_taxamatch(dat$Name[i]))
      templist[i,] <- wm[1,]
    }, error = function(e) {

      # Do nothing
    })
    setTxtProgressBar(pb, i) # Update progress bar
  }
  close(pb) # Close progress bar

  # Restart at i = 40961
write_rds(templist, "TempList.rds")




  wm <- bind_rows(worrms::wm_records_names(dat$Name[1]))



  # I originally tried purrr but it failed. Here at least I can extract the row it
  # failed on more easily to investigate if needed.
  # templist <- purrr::map(dat2, ~worrms::wm_records_names(.x$Name, marine_only = FALSE))


  # Now choose the species ------------------------------------------------------
  pb <- txtProgressBar(min = 0, max = nrow(dat), initial = 1, style = 3) # Initial progress bar

  id <- dplyr::bind_rows(worrms::wm_records_names("Jasus edwardsii", marine_only = FALSE, fuzzy = FALSE)) # Make sure the columns are of the right type. Then overwrite below.

  for (i in 28962:nrow(dat)) {

    temp <- templist[[i]]

    if (nrow(temp) > 0) { # If there is data

      # If there is at least one accepted row, and if more than 1 and they
      # are the same, then keep the first accepted row
      if ("accepted" %in% temp$status) {

        # print("Accepted")
        # Filter to the accepted data
        temp <- temp %>%
          filter(status == "accepted")

        # Only one row of accepted data so we keep it.
        if (nrow(temp) == 1){
          id[i, ] <- temp %>%
            dplyr::mutate(unacceptreason = as.logical(unacceptreason))
        } else if (length(unique(temp$scientificname)) == 1 &
                   length(unique(temp$valid_name)) == 1) { # More than 1 row but they match
          id[i, ] <- temp %>%
            dplyr::first() %>%
            dplyr::mutate(unacceptreason = as.logical(unacceptreason))
        } else {
          browser()
        }
      }

      # else if(length(unique(temp$valid_name)) == 1) { # There is only 1 valid name regardless so we run with it
      #
      #   temp2 <- worrms::wm_records_name(temp$valid_name[1], marine_only = FALSE, fuzzy = FALSE)
      #
      #   id[i,] <- temp2 %>%
      #     # filter(status == "accepted") %>%
      #     dplyr::mutate(unacceptreason = as.logical(unacceptreason))
      #   rm(temp2)
      #
      #
      # }

      # Species is uncertain so just use it
      else if (nrow(temp) == 1 &
               temp$status[1] %in% c("taxon inquirendum", "nomen dubium", "nomen nudum", "uncertain", "interim unpublished", "unassessed")) {

        print("1 row Doubtful description")

        # taxon inquirendum - The species may or may not be valid and requires further investigation so we need to use it
        # nomen dubium - A scientific name that is of unknown or doubtful application
        # nomen nudum - A name not adequately described in the literature
        id[i, ] <- temp %>%
          dplyr::mutate(unacceptreason = as.logical(unacceptreason))
      }


      else { # accepted not in the status so we need to decide if we keep anything


        # Clean up
        temp <- temp %>%
          dplyr::filter(is.na(valid_name) == FALSE) # %>% # Remove rows without valid names
        # dplyr::filter(str_detect(unacceptreason, "junior homonym", negate = TRUE) %>% replace_na(TRUE)) # Remove Junior homonyms


        # I only remove "original combination" if there is an alternative
        if (nrow(temp) > 1){
          temp <- temp %>%
            dplyr::filter((unacceptreason != "original combination") %>% replace_na(TRUE)) # Remove original names which have been superseded
        }

        # I only remove "superceded combination" if there is an alternative
        # if (nrow(temp) > 1){
        #   temp <- temp %>%
        #     dplyr::filter((status != "superseded combination") %>% replace_na(TRUE)) # Remove superseded names
        # }

        # I only remove "misapplication" if there is an alternative
        if (nrow(temp) > 1){
          temp <- temp %>%
            dplyr::filter(status != "misapplication")
        }
        if (nrow(temp) == 1){

          # Species is uncertain so just use it
          if (temp$scientificname == temp$valid_name &
              unique(temp$status) %in% c("taxon inquirendum", "nomen dubium", "nomen nudum", "uncertain", "interim unpublished", "unassessed")) {

            # unaccepted <- c("nomen nudum", "interim unpublished")
            # uncertain <- c("uncertain", "taxon inquirendum", "nomen dubium", "unassessed")

            print("Multirow doubtful description")

            # taxon inquirendum - The species may or may not be valid and requires further investigation so we need to use it
            # nomen dubium - A scientific name that is of unknown or doubtful application
            # nomen nudum - A name not adequately described in the literature
            id[i, ] <- temp %>%
              dplyr::mutate(unacceptreason = as.logical(unacceptreason))

            # Species has different valid name so get new data
          } else if (temp$scientificname != temp$valid_name) { # Get the data for the valid name

            print("New valid name 1")

            temp2 <- worrms::wm_record(temp$valid_AphiaID[1])

            if ("accepted" %in% temp2$status) {
              id[i,] <- temp2 %>%
                filter(status == "accepted") %>%
                dplyr::mutate(unacceptreason = as.logical(unacceptreason))
            } else {
              id[i,] <- temp2[1,] %>%
                dplyr::mutate(unacceptreason = as.logical(unacceptreason))
            }
            rm(temp2)

            # Species is not an accepted name, but there is no better option so we use it
          } else if (temp$scientificname == temp$valid_name) { # Get the data for the valid name

            print("Scientific Name")

            id[i, ] <- temp %>%
              dplyr::mutate(unacceptreason = as.logical(unacceptreason))

          } else {


            browser()
          }

          # There is only one valid name so we use that
        } else if (length(unique(temp$valid_name %>% na.omit())) == 1){ # Get the data for the valid name

          print("New valid name 2")

          temp2 <- worrms::wm_records_name(temp$valid_name %>%
                                             na.omit() %>%
                                             dplyr::first(), marine_only = FALSE, fuzzy = FALSE)

          if ("accepted" %in% temp2$status) {
            id[i,] <- temp2 %>%
              filter(status == "accepted") %>%
              dplyr::mutate(unacceptreason = as.logical(unacceptreason))
          } else {
            id[i,] <- temp2[1,] %>%
              dplyr::mutate(unacceptreason = as.logical(unacceptreason))
          }

          rm(temp2)

        } else if (sum(temp$status %in% "alternative representation") > 0) {

          print("Alt. Representation")

          temp2 <- worrms::wm_record(id = temp %>%
                                       dplyr::filter(status == "alternative representation") %>%
                                       dplyr::pull(valid_AphiaID))

          if ("accepted" %in% temp2$status) {
            id[i,] <- temp2 %>%
              filter(status == "accepted") %>%
              dplyr::mutate(unacceptreason = as.logical(unacceptreason))
          } else {
            id[i,] <- temp2[1,] %>%
              dplyr::mutate(unacceptreason = as.logical(unacceptreason))
          }

        } else if (sum(temp$status %in% "junior homonym") > 0) {

          print("Junior homonym")

          temp2 <- worrms::wm_record(id = temp %>%
                                       dplyr::filter(status == "junior homonym") %>%
                                       dplyr::pull(valid_AphiaID))

          if ("accepted" %in% temp2$status) {
            id[i,] <- temp2 %>%
              filter(status == "accepted") %>%
              dplyr::mutate(unacceptreason = as.logical(unacceptreason))
          } else {
            id[i,] <- temp2[1,] %>%
              dplyr::mutate(unacceptreason = as.logical(unacceptreason))
          }
          #   temp2 <- worrms::wm_records_name(temp %>%
          #                                      filter(unacceptreason == "wrong gender") %>%
          #                                      dplyr::pull(valid_name),
          #                                    marine_only = FALSE, fuzzy = FALSE)
          #
          #   if ("accepted" %in% temp2$status) {
          #     id[i,] <- temp2 %>%
          #       filter(status == "accepted") %>%
          #       dplyr::mutate(unacceptreason = as.logical(unacceptreason))
          #   } else {
          #     id[i,] <- temp2[1,] %>%
          #       dplyr::mutate(unacceptreason = as.logical(unacceptreason))
          #   }

          # I want to look at a few options before deciding what to do
        } else if (unique(temp$scientificname) %in% c("Achnanthes taeniata", "Actinocyclus curvatulus", "Arcoscalpellum formosum", "Arca reticulata",
                                                      "Aspidosiphon hartmeyeri", "Astroceras pergamena", "Axinella rugosa", "Bittium variegatum")) {

          print("Specific species")

          temp2 <- worrms::wm_records_name(temp$valid_name[1], marine_only = FALSE, fuzzy = FALSE)

          id[i,] <- temp2 %>%
            dplyr::mutate(unacceptreason = as.logical(unacceptreason))

        } else {

          print("No other options")

          browser()
        }

      }
    } else { # If there is no data
      id[i, ] <- NA
    }

    rm(temp)
    setTxtProgressBar(pb, i) # Update progress bar
  }
  close(pb) # Close progress bar

  # Add wm_ prefix to column names
  colnames(id) <- paste0("wm_", colnames(id))

  return(id)
  #### Species names now up to date. ####
}
