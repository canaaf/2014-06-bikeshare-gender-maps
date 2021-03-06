default:
	@echo "No default rule"

# Processing

DATES = 2013-07-01 2013-11-30
PROCESS = python scripts/process-data.py --date-range $(DATES)

nyc: cmd = $(PROCESS) --program nyc \
	--trips raw-data/nyc-merged.csv \
	--stations raw-data/nyc-merged.csv 
nyc:
	$(cmd) --filetype geojson > html/data/nyc.geojson
	$(cmd) --filetype csv > html/data/nyc.csv

chicago: cmd = $(PROCESS) --program chicago \
	--trips raw-data/Divvy_Stations_Trips_2013/Divvy_Trips_2013.csv \
	--stations raw-data/Divvy_Stations_Trips_2013/Divvy_Stations_2013.csv
chicago:
	$(cmd) --filetype geojson > html/data/chicago.geojson
	$(cmd) --filetype csv > html/data/chicago.csv

boston: cmd = $(PROCESS) --program boston \
	--trips raw-data/hubway-updated-26-feb-2014/hubwaydata_10_12_to_11_13.csv \
	--stations raw-data/hubway-updated-26-feb-2014/stations_10_12_to_11_13.csv
boston:
	$(cmd) --filetype geojson > html/data/boston.geojson
	$(cmd) --filetype csv > html/data/boston.csv

# S3

PROJECT = /projects/2014-06-bikeshare-gender-maps/
S3CMD = aws s3 sync --acl public-read --exclude "assets/*" html/

s3-dev: BUCKET = s3://datadev.buzzfeed.com
s3-dev: PROFILE = --profile datadev
s3-dev:
	 $(S3CMD) $(BUCKET)$(PROJECT) $(PROFILE)

s3-prod: BUCKET = s3://data.buzzfeed.com
s3-prod: PROFILE = --profile data
s3-prod:
	$(S3CMD) $(BUCKET)$(PROJECT) $(PROFILE)
