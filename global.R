if(!file.exists("data/allzips.csv")){
  zips <- read.csv("data/zip_codes_states.csv", header = TRUE, sep = "," , quote = NULL, comment='' )[, c("zip_code","latitude","longitude","city","state")]
  masters <- read.csv("data/MASTER.txt", header = TRUE, sep = "," ,quote = NULL, comment='' )[, c("MFR_MDL_CODE","ENG_MFR_MDL","YEAR_MFR","NAME","ZIPCODE", "COUNTRY")] 
  crafts <- read.csv("data/ACFTREF.txt", header = TRUE, sep = "," ,quote = NULL, comment='' )[, c("AC_CODE","AC_MFR","AC_MODEL","NO_ENG","NO_SEATS","AC_WEIGHT","SPEED")]
  engines <- read.csv("data/ENGINE.txt", header = TRUE, sep = "," ,quote = NULL, comment='' )[, c("ENG_CODE","ENG_MFR","ENG_MODEL")]
  masters <- subset(masters, as.numeric(masters$YEAR_MFR) > 1980 & as.numeric(masters$ZIPCODE) > 1 & masters$COUNTRY =="US" )
  masters$ZIPCODE <- formatC(substr(masters$ZIPCODE,0,5), format="d", width=5,  flag="0")

  zips$zip_code=formatC(substr(zips$zip_code,0,5), format="d", width=5,  flag="0")
  acraft_models <- me.aghoo.masters, crafts, by.x="MFR_MDL_CODE", by.y="AC_CODE")
  models <- me.aghoo.acraft_models, engines, by.x="ENG_MFR_MDL", by.y="ENG_CODE")
  allzips <- me.aghoo.models, zips, by.x="ZIPCODE", by.y="zip_code")
  allzips$latitude <- jitter(as.numeric(allzips$latitude))
  allzips$longitude <- jitter(as.numeric(allzips$longitude))
  allzips <- allzips[complete.cases(allzips),]
  rm(zips, masters, models, engines, acraft_models)
  #head(allzips)
  write.table(allzips,"data/allzips.csv",sep=",",row.names=F,col.names=T,append=T,quote=F)
} else {
  allzips <- read.csv("data/allzips.csv", header = TRUE, sep = "," , quote = NULL, comment='' )
  allengines <- read.csv("data/ENGINE.txt", header = TRUE, sep = "," ,quote = NULL, comment='' )[, c("ENG_CODE","ENG_MFR","ENG_MODEL")]
}
