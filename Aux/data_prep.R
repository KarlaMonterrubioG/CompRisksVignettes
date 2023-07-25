
# Load the input data
require(readr)
hd <- data.frame(read_csv("../Data/HD/hd.csv",
                          col_types = cols(X1 = col_skip())))

# Convert relevant variables into factors
hd$sex      <- as.factor(hd$sex)
hd$trtgiven <- as.factor(hd$trtgiven)
hd$medwidsi <- as.factor(hd$medwidsi)
hd$extranod <- as.factor(hd$extranod)
hd$clinstg  <- as.factor(hd$clinstg)

# Split the data into training and testing sets
require(splitstackshape)
set.seed(2022)
split_data <- stratified(hd, c("status"), 0.8, bothSets = TRUE)
hd_train   <- split_data$SAMP1
hd_test    <- split_data$SAMP2

cat("The sourced script has been used to load and pre-process the data.\n",
    "The latter converts appropriate variables into factors.\n",
    "Additionally, we randomly split the data into training and testing sets, \n",
    "enabling us to evaluate out-of-sample predictive performance when comparing different approaches.")
