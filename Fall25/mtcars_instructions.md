# 🚗 DS400 Mini-Lab: Exploring `mtcars` in a Quarto Document

In this mini-lab, you’ll work with the `mtcars` dataset and practice using R, Quarto, and tidyverse for data exploration and visualization. Follow the steps carefully and complete all tasks.

---

## ✅ Tasks

### 1. Download the Data
- Go to the class GitHub repository and download the `mtcars.csv` file:  
  [mtcars.csv](https://github.com/NSF-ALL-SPICE-Alliance/DS422-Geocomputation/blob/main/data/mtcars.csv)  
- Save the file into your **local project folder**:  
  `DS400/data/mtcars.csv`

---

### 2. Create a New Quarto Document
- In RStudio, create a new **Quarto Document**.
- Save it in your project root as:  
  `mtcars_exploration.qmd`

---

### 3. Load Required Libraries
- At the top of your `.qmd` file, load the following libraries with the `library()` function:
  - `here`
  - `tidyverse`

---

### 4. Import the Dataset
- Use `here()` and `read_csv()` to import `mtcars.csv` into R.
- Save it as a dataframe called `mtcars_df`.

---

### 5. Explore the Data
- Look at the dataset by **clicking the dataframe** in the Environment pane.
- Run a few quick commands to view the data structure and summary.

---

### 6. Make Visualizations with ggplot2

1. **Scatter Plot**  
   - Create a scatter plot of two variables: weight (wt) and miles per gallon (mpg).

2. **Scatter Plot with Color**  
   - Create the same scatter plot but add color **colored by number of cylinders**.

3. **Histogram**  
   - Make a histogram of miles per gallon.

---

### 7. Feature Engineering: Separate Make & Model
- The dataset contains a column called `make_model`.  
- Separate it into **two new columns**:  
  - `make`  
  - `model`  

---

### 8. Using 'ggplot()' for Box Plot with Jitter
- Using your new `make` column:
  - Create a **box plot** of `mpg` by `make`.
  - Add **jittered points** to show individual observations.

---

## 🎯 Deliverables
By the end of this exercise, your `.qmd` file should include:

- Properly imported dataset from `data/mtcars.csv`
- At least **4 plots**:
  1. Scatter plot
  2. Scatter plot with color
  3. Histogram
  4. Box + jitter plot
- A cleaned dataset with new `make` and `model` columns

---

## 💡 Tips
- Use `theme_minimal()` or other ggplot themes to make your plots look professional.
- Add titles and axis labels to your plots with the labs() function

---
