### Solar Detection Assignment

Goal is to answer the question: "Is there a relationship/correlation between median income and solar infrastructure at the census tract level"?. 
This will be the final addition to the manuscript: Island-Wide Photovoltaic Infrastructure Detection on Oahu, Hawai'i Using SAM3 and High-Performance Computing

How to get there:
1. Understand the [Segment Anything Model 3](https://www.youtube.com/watch?v=G4OLPDjwncw). Read the write-up from our manuscript
2. Understand how we can utilize this model in R with [geosam](https://walker-data.com/geosam/index.html). Run the code in the [getting started](https://walker-data.com/geosam/articles/getting-started.html) to recreate a small example
3. Read the methods section of the manuscript to understand how the model was utilized on the TACC vista supercomputer
4. Download the [solar predictions geojson](https://github.com/NSF-ALL-SPICE-Alliance/DS422-Geocomputation/blob/main/data/oahu_solar_dedup_simple.geojson) and map the data. Run some summary statistics, compare polygon overlays with satellite imagery basemap
5. 
