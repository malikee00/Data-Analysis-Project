# Walmart Sales Analysis using SQL
by Kaamil Nailal Muna

## About
This project seeks to analyze Walmart Sales data with the goal of gaining insights into the performance of various branches and products. The focus includes examining the sales trends of different products and understanding customer behavior. The objective is to explore opportunities for enhancing and optimizing sales strategies. The dataset utilized is sourced from the Kaggle Walmart Sales Forecasting Competition.

"In this recruitment competition, participants are provided with historical sales data for 45 Walmart stores situated in diverse regions. Each store comprises multiple departments, and the task involves predicting the sales for each department within each store. Additionally, the dataset includes information about selected holiday markdown events. These markdowns are acknowledged to impact sales, but predicting the specific departments affected and the magnitude of the impact presents a challenge."

## Step by Step

1. **Data Wrangling:** This is the first step where inspection of data is done to make sure **NULL** values and missing values are detected and data replacement methods are used to replace, missing or **NULL** values.

> 1. Build a database
> 2. Create table and insert the data.
> 3. Select columns with null values in them. There are no null values in our database as in creating the tables, we set **NOT NULL** for each field, hence null values are filtered out.

2. **Feature Engineering:** This will help use generate some new columns from existing ones.

> 1. Add a new column named `time_of_day` to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.

> 2. Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

> 3. Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

2. **Exploratory Data Analysis (EDA):** Exploratory data analysis is done to answer the listed questions and aims of this project.

3. **Conclusion:**

## Business Questions To Answer

### Generic Question

1. How many unique cities does the data have?
2. In which city is each branch?

### Product

1. How many unique product lines does the data have?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. What month had the largest COGS?
6. What product line had the largest revenue?
5. What is the city with the largest revenue?
6. What product line had the largest VAT?
7. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
8. Which branch sold more products than average product sold?
9. What is the most common product line by gender?
12. What is the average rating of each product line?

### Sales

1. Number of sales made in each time of the day per weekday
2. Which of the customer types brings the most revenue?
3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
4. Which customer type pays the most in VAT?

### Customer

1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day fo the week has the best avg ratings?
10. Which day of the week has the best average ratings per branch?

## Result
- The type of product that is sold the most is electronic accessories, second is food, while the least is health and beauty
- The payment method that is often used is e-wallet
- The highest total revenue is in January
- The type of product that sells the most is food and beverages, and the least is health and beauty
- The city with the most sales is Naypyitaw,
- The type of product with the most significant tax presentation is home and lifestyle
- Common product types based on gender are primarily female, with the top ranking being fashion accessories and food beverages, then the least is female with health and beauty
- The highest average rating based on product line is food and beverages, with a rating of 7.11, and the lowest is home and lifestyle, with a rating of 6.84
- The highest total sales are on Saturday afternoons or Sunday evenings with total sales of 81, then the fewest are on Monday mornings with total sales of 21
- The customers who make the most sales are member customers rather than regular customers
- Napytaw also has the highest average taxes
- Most customers are women
- Male customers dominate most existing branches, wildly branches A and B
- The time when customers are given the most ratings is during the day
- The branch with the highest product rating is branch C, with most of it given during the day, while the unit with the lowest average rating is branch B
- The day with the most average product ratings is Monday

## Suggestion
**1. Optimization of Product Portfolio and Marketing Strategy**
The first step is to conduct an in-depth sales data analysis for electronic accessories and food products to optimize the product portfolio and marketing strategy. The results of this analysis form the basis for adjusting the product portfolio, focusing on improving quality, and understanding customer needs. Next, companies can design focused marketing strategies for the health and beauty categories, including special promotions, the use of online platforms, and the implementation of customer loyalty programs. Additionally, strategic partnerships with brands or influencers can help expand market reach.

It's also important to stay adaptable to change, involving constant evaluation and adjustment based on customer feedback, competitor analysis, and monitoring market trends. In addition, implementing special discounts or promotions can be an effective way to increase product appeal. Thus, through this holistic approach, companies can achieve product portfolio optimization and marketing strategies that support sustainable growth and competitive advantage.

**2. Innovation in Payment Method**
To develop innovation in payment methods at Walmart:
Focus on the latest technologies, such as QR codes and contactless payments, to meet the needs of modern customers.
Investigate potential collaborations with financial service providers and prioritize transaction security with strong encryption.
Design special incentive programs, such as discounts and loyalty points, to drive the adoption of e-wallet payments and strengthen integration with Walmart mobile apps.

The importance of educating customers about the security and benefits of payments using e-wallets must also be emphasized. Additionally, consider developing an in-house payment solution to provide Walmart more flexibility and control. Integration of payment methods with loyalty systems and user data analysis can create a holistic shopping experience. Always be responsive to customer feedback and continuously improve customer satisfaction. By combining these steps, Walmart can strengthen its position in the world of e-commerce with a payment system that is innovative and responsive to customer needs.

**3. Increase in Sales in Certain Periods**
Walmart can increase sales over a certain period with an integrated strategy. First, focus on dedicated marketing campaigns that offer special offers and discounts on seasonally related products by leveraging product bundling and optimizing loyalty programs. Through online and offline promotional campaigns, including technology to increase customer engagement, Walmart can ensure that seasonally relevant products are available and adequate. Furthermore, companies can establish strong partnerships with suppliers to ensure sufficient supply and negotiate special conditions to increase profits. Once the sales period is complete, conduct an in-depth results analysis to identify successes and opportunities for improvement so that marketing and sales strategies can be adjusted to increase effectiveness in the future.

By combining these steps, Walmart can create a holistic and responsive approach to changing customer demands, improve sales performance, and strengthen its position as a top choice in the retail industry.

**4. Location Based Sales Achievement**
Walmart can achieve increased location-based sales in Naypyitaw by focusing on a deep understanding of the local market. Through market analysis and customer segmentation, Walmart can adjust product stock, prices, and marketing campaigns better to suit the preferences and needs of customers in Naypyitaw. Collaboration with local businesses, participation in community activities, and increased personal customer service can help build strong ties with local communities, improve Walmart's image, and accelerate sales growth at that location.

With the support of local employees and analytical data for performance monitoring, Walmart can respond to market changes more quickly and effectively. In this way, Walmart will be a globally efficient shopping center and a competitive and responsive member of Naypyitaw's local business ecosystem. Through this combination of strategies, it is hoped that Walmart can strengthen its presence in Naypyitaw and provide significant added value to local customers.

**5. Personalize Customer Experience**
Walmart can increase the personalization of customer experiences with a holistic approach. First, through in-depth analysis of customer data and segmentation based on preferences, gender, and membership, Walmart can craft offerings that better suit the needs of each customer segment. A particular focus on the fashion accessories and food and beverages categories for female customers and increasing membership programs with exclusive privileges can provide added value to more personalized customers.

Furthermore, personalization strategies can be enhanced by analyzing purchasing patterns and responses to product ratings on certain days, especially Mondays. Through personalized communications, rapid responses to customer trends, and customer engagement in providing feedback, Walmart can create a more relevant shopping experience and strengthen customer engagement. The importance of maintaining customer data security and compliance is also the basis for building trusting and sustainable relationships with customers. By combining these elements, Walmart can provide more unique and customized customer experiences, increase loyalty, and achieve sustainable growth.
