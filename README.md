# 📊 Shiny Dashboard: Plotting Basic Graphs

This Shiny app provides an interactive dashboard for visualizing data through univariate and bivariate plots. Users can upload their own datasets (CSV or Excel), create plots, and download them in a Word document format.

---

## 🚀 Features

- Upload `.csv` or `.xlsx` files
- Preview uploaded data
- Plot **univariate graphs**:
  - Bar plot for categorical variables
  - Histogram for numeric variables (with adjustable bins)
- Plot **bivariate graphs**:
  - Scatter plots
  - Box plots
- Export generated plots to a `.docx` Word file
- Responsive layout with navigation and a footer for contact

---

## 🛠️ Installation

### Prerequisites

Make sure the following R packages are installed:

```r
install.packages(c(
  "shiny", "shinydashboard", "shinyWidgets", 
  "readxl", "ggplot2", "officer", "rvg"
))
