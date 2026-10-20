# Retail Sales Analysis — Excel, MySQL & Power BI

## Executive Summary

This project uses one retail transactions dataset across Excel, MySQL, and Power BI to review sales, product, regional, and monthly performance. The repository reports 5,000 transactions, 200 customers, 50 products, and 5 stores.

The project is relevant to retail sales, reporting, and BI analyst roles because it connects data preparation, metric calculation, SQL analysis, and dashboard reporting. The source and license for the dataset are not documented in the current project files, so the results should be treated as analysis of the included project dataset rather than a claim about a named retailer.

## Business Problem

A retail team needs a consistent view of what is selling, where sales are concentrated, and how discounts affect gross profit. The analysis is intended to support decisions about which regions, categories, and products deserve further commercial review.

Questions addressed:

- Which regions and categories contribute the most sales?
- Which products lead by discounted sales value?
- How do sales and modeled gross profit change over time?
- Where should the team investigate product mix, discounts, or seasonal demand?

## Methodology

The dataset contains customer, product, store, and transaction tables. The workflow prepares the data in Excel, stores the four entities in MySQL, builds a sales view, and connects the analytical output to Power BI.

| Metric | Definition used |
|---|---|
| Revenue | `quantity × unit_price × (1 − discount)`; discount is stored as a fraction, such as 0.10 for 10% |
| Gross profit | `quantity × (unit_price × (1 − discount) − cost_price)`; before operating costs, taxes, shipping, and other expenses |
| Transactions | Count of distinct `transaction_id` values |
| Units sold | Sum of transaction `quantity` |
| Monthly revenue | Sum of revenue grouped by calendar year and month |

The discount and profit definitions are documented in the SQL view. The calculations do not include returns or non-product operating expenses.

## Skills

- **Excel:** data preparation, calculated fields, PivotTables, dashboard reporting
- **MySQL:** relational tables, joins, views, aggregation, KPI calculations
- **Power BI:** interactive reporting and filters
- **Analytics:** metric definition, regional and product comparison, trend interpretation

## Results & Business Recommendation

| Evidence in the existing analysis | Practical follow-up |
|---|---|
| The East region is reported as the highest-revenue region at approximately ₹5.6M. | Review its leading products, discounting, and store mix before shifting resources. |
| Electronics is reported as the leading category. | Compare its gross profit and unit trends with other categories before expanding promotions. |
| The dashboard shows mid-year monthly sales peaks. | Use this as a planning signal, then confirm the pattern against additional years before treating it as seasonality. |
| A small group of products contributes a large share of sales. | Check product availability and margin concentration; the current project does not include inventory data. |

These are descriptive findings from the included dataset. They do not show that a promotion caused a sales change or establish what would happen after a business action.

### Dashboard previews

**Excel dashboard**

![Excel Dashboard](images/excel_dashboard.png)

**Power BI dashboard**

![Power BI Dashboard](images/powerbi_dashboard.png)

## Next Steps

1. Add the dataset source, generation method, and license to the repository.
2. Reconcile the headline findings against the saved workbook, SQL outputs, and Power BI visuals.
3. Add margin by region/category and discount-depth analysis.
4. Add multiple years or a comparison period before making seasonal recommendations.
5. Add inventory and returns data before making stock or net-sales claims.

### Run and review

- Open `excel/Retail_Sales_Analysis_Excel_Project.xlsx` for the Excel dashboard.
- Run `sql/retail_sales_analysis.sql` in MySQL after loading the CSV files from `datasets/`.
- Open `power-bi/retail_sales_dashboard.pbix` in Power BI Desktop.

**Author:** Salahuddin K M · [Portfolio](https://erskm.github.io) · [GitHub](https://github.com/ErSKM)
