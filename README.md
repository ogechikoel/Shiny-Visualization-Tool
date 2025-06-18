# 📊 Shiny Dashboard: Plotting Basic Graphs

This Shiny app provides an interactive dashboard for visualizing data through univariate and bivariate plots. Users can upload their own datasets (CSV or Excel), create plots, and download them in a Word document format.

---
## 🌐 Live Demo

Try the app online: [Basic Charts Dashboard](https://daniel-koel.shinyapps.io/basic-charts-dashboard/)

---

## 🚀 Features

- Upload `.csv` or `.xlsx` files  
- Preview uploaded data  
- Plot **univariate graphs**:  
  - Bar plots for categorical variables  
  - Histograms for numeric variables (with adjustable bins)  
- Plot **bivariate graphs**:  
  - Scatter plots  
  - Box plots  
- Export generated plots to a `.docx` Word file  
- Responsive layout with navigation and a footer for contact information  

---

## 📤 Exporting Plots

Click the **"Download Word Document"** button to download both the univariate and bivariate plots in a formatted `.docx` file.

---

## 🛠️ Installation

### Prerequisites

Make sure the following R packages are installed:

```r
install.packages(c(
  "shiny", "shinydashboard", "shinyWidgets", 
  "readxl", "ggplot2", "officer", "rvg"
))
