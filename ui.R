library(leaflet)

# Choices for drop-downs
#vars_1 <- lapply(allzips[!duplicated(allzips$AC_MFR), ]$AC_MFR, as.character)
#vars_2 <- lapply(allengines[!duplicated(allengines$ENG_MFR) & order(allengines$ENG_MFR, decreasing=T), ]$ENG_MFR, as.character)
vars_2 <- lapply(allzips[!duplicated(allzips$ENG_MFR) & order(allzips$ENG_MFR, decreasing=T), ]$ENG_MFR, as.character)
vars_1 <- c(
  "CLASS 1" = "CLASS 1",
  "CLASS 2" = "CLASS 2",
  "CLASS 3" = "CLASS 3",
  "CLASS 4" = "CLASS 4"
)


navbarP.aghoo."Aircraft & Engine", id="nav",
  #navbarMenu("More", icon="data.aghoo.engine.jpeg"),
  #title=div(img(src=.aghoo.engine.jpg",height=36,width=36), " Aircraft & Engine"),id="nav",
  tabPanel("Interactive map",
    div(class="outer",

      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),

      leafletOutput("map", width="100%", height="100%"),

      # Shiny versions prior to 0.11 should use class="modal" instead.
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, right = "auto", left = 20, bottom = "auto",
        width = 400, height = "auto",

        img(src=.aghoo.aviation.jpg",height=60,width=210),
	h2("Aircraft Specification"),

        #selectInput("engine_mfr", "Engine Manufatectuer", vars_1, selected = "ALL"),
	#selectizeInput("ac_mfr", "Aircraft Manufatectuer", choices=vars_1 ),
	sliderInput("reg_year", "Aircraft Rigistration Since:",
                min = 1980, max = 2017, value = 1990, step = 1),
        selectizeInput("engine_mfr", "Engine Manufatectuer", choices=vars_2, selected = "GE" ),
        selectInput("ac_class", "Aircraft Class", vars_1, selected = "CLASS 3", multiple=F),
	conditionalPanel( exists("input.engine_mfr"),
		selectizeInput("acraft_model", "Aircraft Model", c("All acraft_models"=""), multiple=TRUE)
	),

        #conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
        #  # Only prompt for threshold when coloring or sizing by superzip
        #  numericInput("threshold", "Market Share (top n percentile)", 5)
        #),

        plotOutput("histCentile", height = 450)
        #plotOutput("scatterColl.aghoo.ncome", height = 250)
      ),

      tags$div(id="cite",
        'Data compiled from ', tags$em('FAA and other sources for GE demo purpose'), ' by Alfred and Haitao (c) 2016.'
      )
    )
  ),


  tabPanel("Aircraft Explorer",
    fluidRow(
      column(3,
        selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
      ),
      column(3,
        conditionalPanel("input.states",
          selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
        )
      ),
      column(3,
        conditionalPanel("input.states",
          selectInput("ac_models", "Aircraft Model", c("All ac_model"=""), multiple=TRUE)
        )
      ),
      column(3,
        conditionalPanel("input.states",
          selectInput("eng_mfrs", "Engine Maunfacturer", c("All eng_mfrs"=""), multiple=TRUE)
        )
      )
    ),
    hr(),
    DT::dataTableOutput("ziptable")
  ),

  conditionalPanel("false", icon("crosshair"))
)
