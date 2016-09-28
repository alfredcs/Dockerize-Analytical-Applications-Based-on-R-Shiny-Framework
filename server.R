library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(plotrix) # For pie3D

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
#zipdata <- allzips[sample.int(nrow(allzips), 10000),]
#zipdata <- allzips[trimws(allzips$AC_WEIGHT) %in% "CLASS 3",]   #Display only Class 3 aircraft
#zipdata <- allzips[trimws(allzips$AC_WEIGHT) %in% input$ac_class,  c("ZIPCODE", "latitude", "longitude", "AC_MODEL", "ENG_MFR")] 
# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see
#ifelse(is.null(input$engine_mfr),  allzips <- allzips[order(allzips$year_mfr),], allzips <- allzips[order(allzips$year_mfr) & allzips$eng_mfr %in% "input$engine_mfr", ])
#zipdata <- zipdata[order(zipdata$YEAR_MFR),]
#ifelse(is.null(input$engine_mfr),  allzips <- allzips[order(allzips$year_mfr),], allzips <- allzips[order(allzips$year_mfr) & allzips$eng_mfr %in% "input$engine_mfr", ])

function(input, output, session) {
#ifelse(is.null(input$engine_mfr),  allzips <- allzips[order(allzips$year_mfr),], allzips <- allzips[order(allzips$year_mfr) & allzips$eng_mfr %in% "input$engine_mfr", ])

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 5)
  })

  # A reactive expression that returns the set of zips that are
  # in bounds right now
  zipsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(allzips[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)

    subset(allzips,
      latitude >= latRng[1] & latitude <= latRng[2] &
      longitude >= lngRng[1] & longitude <= lngRng[2])
  })

 # # Output engine model based by MFR selected
  observe({
    engine_models <- if (is.null(input$engine_mfr)) character(0) else {
      filter(allzips, ENG_MFR %in% input$engine_mfr, AC_WEIGHT %in% input$ac_class ) %>%
        `$`('AC_MODEL') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$engine_models[input$engine_models %in% engine_models])
    updateSelectInput(session, "acraft_model", choices = lapply(engine_models, as.character),
      selected = stillSelected)
  })

  # Precalculate the breaks we'll need for the two histograms
  #centileBreaks <- hist(plot = FALSE, allzips$centile, breaks = 20)$breaks

  #output$histCentile <- renderPlot({
  #  # If no zipcodes are in view, don't plot
  #  if (nrow(zipsInBounds()) == 0)
  #    return(NULL)
#
#    hist(zipsInBounds()$centile,
#      breaks = centileBreaks,
#      main = "SuperZIP score (visible zips)",
#      xlab = "Percentile",
#      xlim = range(allzips$centile),
#      col = '#00DD00',
#      border = 'white')
#  })
#

   output$histCentile <- renderPlot({
     dd2 <- zipsInBounds() %>%
       count(ENG_MFR) %>%
       top_n(10) %>%
       arrange(n, ENG_MFR) %>%
       mutate(ENG_MFR = factor(ENG_MFR, levels = unique(ENG_MFR)))
     slices <-as.matrix(unlist(dd2[2]))
     lbls <- lapply(unlist(dd2[1]), as.character)
     pct <- round(slices/sum(slices)*100)
     lbls <- paste(lbls, pct) # add percents to labels 
     lbls <- paste(lbls,"%",sep="") # ad % to labels 
     if (nrow(zipsInBounds()) == 0)
       return(NULL)
     pie3D(slices,labels=lbls,explode=0.1,labelcex=0.75,main="Top 10 Engine Market Shares")
   })
#  output$scatterCollegeIncome <- renderPlot({
#    # If no zipcodes are in view, don't plot
#    if (nrow(zipsInBounds()) == 0)
#      return(NULL)
#
#    print(xyplot(income ~ college, data = zipsInBounds(), xlim = range(allzips$college), ylim = range(allzips$income)))
#  })

  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
 
  observe({
    colorBy <- "supersize"
    #ifelse( exists(input$acraft_model), acModel <-input$acraft_model, acModel<-NULL)
    bb <- paste(input$engine_mfr, input$acraft_model, sep="/")
    selections <- c("ZIPCODE", "latitude", "longitude", "NO_ENG", "AC_MODEL", "ENG_MFR")
    zipdata <- allzips[trimws(allzips$AC_WEIGHT) %in% input$ac_class & as.numeric(allzips$YEAR_MFR) > as.numeric(input$reg_year), selections ]

    if (colorBy == "superzip") {
      # Color and palette are treated specially in the "superzip" case, because
      # the values are categorical instead of continuous.
      #colorData <- ifelse(zipdata$centile >= (100 - input$threshold), "yes", "no")
      colorData <- ifelse(2>1, "yes", "no")
      pal <- colorFactor("Spectral", colorData)
    } else {
      colorData <- zipdata[[colorBy]]
      pal <- colorBin("Spectral", colorData, 7, pretty = FALSE)
    }
    radius<-3700
    selections <- c("ZIPCODE", "latitude", "longitude", "NO_ENG", "AC_MODEL", "ENG_MFR")
    if (is.null(input$acraft_model) || is.na(input$acraft_model)){
    	if( trimws(input$engine_mfr) == "NONE") 
	  zipdata <- allzips[ (trimws(allzips$AC_WEIGHT) %in% input$ac_class & is.null(input$engine_mfr)|grepl(input$engine_mfr, allzips$ENG_MFR) & as.numeric(allzips$YEAR_MFR) > as.numeric(input$reg_year) ), selections ]   
	else
	  zipdata <- allzips[ (trimws(allzips$AC_WEIGHT) %in% input$ac_class  & as.numeric(allzips$YEAR_MFR) > as.numeric(input$reg_year) ), selections ]   
	
    } else {
    	zipdata <- allzips[ ( grepl(input$ac_class, allzips$AC_WEIGHT) & grepl(input$engine_mfr, allzips$ENG_MFR) & grepl(input$acraft_model, allzips$AC_MODEL) & as.numeric(allzips$YEAR_MFR) > as.numeric(input$reg_year) ),  c("ZIPCODE", "latitude", "longitude", "NO_ENG", "AC_MODEL", "ENG_MFR") ]
    }
    bb <- paste(bb, sum(zipdata$NO_ENG),input$ac_class,  sep=":")
    leafletProxy("map", data = zipdata) %>%
      clearShapes() %>%
      addCircles(~longitude, ~latitude, radius=radius, layerId=~ZIPCODE,
        stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=bb,
        layerId="colorLegend")
  })

  # Show a popup at the given location
  showZipcodePopup <- function(zipcode, lat, lng) {
    selectedZip <- allzips[allzips$ZIPCODE == zipcode,]
    #ifelse( mfrBy == "NONE", selectedZip <- allzips[allzips$zipcode == zipcode,], selectedZip <- allzips[allzips$eng_mgr %in% mfrBy & allzips$zipcode == zipcode,] )
    content <- as.character(tagList(
      #tags$h4("Score:", as.integer(selectedZip$centile)),
      tags$h5("ZIPCODE:", selectedZip$ZIPCODE), 
      tags$hr(),
      tags$h5("Aircraft Counts:", nrow(selectedZip)),
      tags$h5("Engine Counts:", sum(selectedZip$NO_ENG)),
      tags$h5("Total Seats:", sum(selectedZip$NO_SEATS)),
      #tags$strong(HTML(sprintf("%s/%s,<br>", selectedZip$AC_MFR,selectedZip$ENG_MFR))),
      tags$br()
      #sprintf("Registered Aircraft: %s", nrow(selectedZip$n_number)), tags$br(),
      #sprintf("Percent of adults with BA: %s%%", as.integer(selectedZip$college)), tags$br(),
      #sprintf("Adult population: %s", selectedZip$adultpop)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = zipcode)
  }
  

  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()

    isolate({
      showZipcodePopup(event$id, event$lat, event$lng)
    })
  })


  ## Data Explorer ###########################################

  observe({
    cities <- if (is.null(input$states)) character(0) else {
      allzips %>%
        filter(state %in% input$states,
	is.null(input$ac_models) | AC_MODEL %in% input$ac_models,
	is.null(input$eng_mfrs) | ENG_MFR %in% input$eng_mfrs) %>%
        `$`('city') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$cities[input$cities %in% cities])
    updateSelectInput(session, "cities", choices = lapply(cities, as.character),
      selected = stillSelected)
  })

  observe({
    ac_models <- if (is.null(input$states)) character(0) else {
      allzips %>%
        #filter(state %in% input$states,
        filter(is.null(input$states) | state %in% input$states,
          is.null(input$eng_mfrs) | ENG_MFR %in% input$eng_mfrs,
          is.null(input$cities) | city %in% input$cities) %>%
        `$`('AC_MODEL') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$ac_models[input$ac_models %in% ac_models])
    updateSelectInput(session, "ac_models", choices = lapply(ac_models, as.character),
      selected = stillSelected)
  })

  observe({
    eng_mfrs <- if (is.null(input$states)) character(0) else {
      allzips %>%
        filter(is.null(input$states) | state %in% input$states, 
          is.null(input$cities) | city %in% input$cities,
          is.null(input$ac_models) | AC_MODEL %in% input$ac_models) %>%
        `$`('ENG_MFR') %>%
        unique() %>%
        sort()
    }
    #ll <- cleantable_allengines[cleantable_allengines$EngineModelID %in% eng_mfr_mdls, ]$EngineMFR
    stillSelected <- isolate(input$eng_mfrs[input$eng_mfrs %in% eng_mfrs])
    updateSelectInput(session, "eng_mfrs", choices = lapply(eng_mfrs,as.character),
      selected = stillSelected)
  })

  observe({
    if (is.null(input$goto))
      return()
    isolate({
      map <- leafletProxy("map")
      map %>% clearPopups()
      dist <- 0.5
      zip <- input$goto$zip
      lat <- input$goto$lat
      lng <- input$goto$lng
      showZipcodePopup(zip, lat, lng)
      map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
    })
  })

  output$ziptable <- DT::renderDataTable({
    df <- subset(allzips, select=c("AC_MODEL","AC_MFR","ENG_MFR","ENG_MODEL", "NO_ENG", "NO_SEATS", "YEAR_MFR", "NAME", "AC_WEIGHT", "city", "state", "ZIPCODE","latitude","longitude")) %>%
      filter(
        #Score >= input$minScore,
        #Score <= input$maxScore,
	#as.numeric(YEAR_MFR) > 1980,
        is.null(input$states) | state %in% input$states,
        is.null(input$cities) | city %in% input$cities,
        is.null(input$ac_models) | AC_MODEL %in% input$ac_models,
        is.null(input$eng_mfrs) | ENG_MFR %in% input$eng_mfrs
      ) %>%
      mutate(Action = paste('<a class="go-map" href="" data-lat="', latitude, '" data-long="', longitude, '" data-zip="', ZIPCODE, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
    action <- DT::dataTableAjax(session, df)

    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
  })
}
