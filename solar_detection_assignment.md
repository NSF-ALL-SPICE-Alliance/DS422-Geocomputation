### Solar Detection Assignment

Due: Thursday October 1st at 11:30 AM

Goal is to answer the question: "Is there a relationship/correlation between median income and solar infrastructure at the census tract level"?. 
This will be the final addition to the manuscript: [Island-Wide Photovoltaic Infrastructure Detection on Oahu, Hawai'i Using SAM3 and High-Performance Computing](https://github.com/NSF-ALL-SPICE-Alliance/DS422-Geocomputation/blob/main/papers/Island-Wide%20Photovoltaic%20Infrastructure%20Detection%20on%20Oahu%2C%20Hawai'i%20Using%20SAM3%20and%20High-Performance%20Computing.docx)

How to get there:
1. Understand the [Segment Anything Model 3](https://www.youtube.com/watch?v=G4OLPDjwncw). Read the write-up from our manuscript
2. Understand how we can utilize this model in R with [geosam](https://walker-data.com/geosam/index.html). Run the code in the [getting started](https://walker-data.com/geosam/articles/getting-started.html) to recreate a small example
3. Read the methods section of the manuscript to understand how the model was utilized on the TACC vista supercomputer
4. Download the [solar predictions geojson](https://github.com/NSF-ALL-SPICE-Alliance/DS422-Geocomputation/blob/main/data/oahu_solar_dedup_simple.geojson) and map the data. Run some summary statistics, compare polygon overlays with satellite imagery basemap
5. Create a map of median income for Oahu at the census tract level
6. Create a map of solar infrastructure in area meters squared at the census tract level
7. Consider normalization
8. Consider dropping large commercial-size polygons from the predictions to more accurately assess the relationship between median income and solar. Thoroughly investigate polygon size distributions and proximities. Are solar farms always one big polygon?
9. Combine your solar infrastructure data and median income data into one spatial dataframe
10. Create a scatter plot of solar infrastructure in area meters squared on the y axis and median income on the x axis. Each point should represent a census tract.
11. Calculate a correlation coefficient and p value to statistically describe the relationship.
12. Write up a one-page-total methods and results section describing your work and the outcomes you observe
13. Push the code and separate write-up to github and submit the link on canvas
