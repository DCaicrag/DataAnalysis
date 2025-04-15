🏡 House Price Prediction – King County, WA

This project performs exploratory data analysis and predictive modeling using a real estate dataset from King County (Seattle, WA area). It includes over 21,000 records of residential properties and focuses on predicting house prices using machine learning techniques.

🎯 Objectives
Explore and analyze relationships between housing features and price.
Apply and compare machine learning models for price prediction.
Evaluate models using MAE, RMSE, and R² metrics.
Perform hyperparameter tuning using Grid Search and Cross-Validation.
📁 Files Included
kc_house_data.csv – Original dataset
eda_modelo_viviendas.ipynb – Complete notebook with EDA and modeling
modelo_random_forest_tuned.pkl – Final saved model
README.md – This document
🧰 Technologies Used
Languages & Libraries:
Python, Pandas, NumPy, Seaborn, Matplotlib, Scikit-Learn, Joblib

Algorithms & Techniques:

Linear Regression
Random Forest Regressor
Feature Engineering and Selection
Hyperparameter Tuning (GridSearchCV)
Cross-Validation (K-Fold, R²)
📊 Dataset Summary
Feature	Mean	Std Dev	Min	Max
Price (USD)	540,088	367,127	75,000	7,700,000
Bedrooms	3.37	0.93	0	33
Bathrooms	2.11	0.77	0	8
Sqft Living	2,079.90	918.44	290	13,540
Sqft Lot	15,106.97	41,420	520	1,651,359
Outliers and skewed distributions were addressed through log transformation and robust model selection.

📈 Model Performance Comparison
Model	MAE (USD)	RMSE (USD)	R² Score
Linear Regression	98,792.26	171,011.57	0.8066
Random Forest	89,949.01	178,363.19	0.7896
Tuned Random Forest	89,629.09	176,227.90	0.7946
Although Linear Regression achieved a slightly higher R², the tuned Random Forest model was preferred due to its lower MAE and better handling of non-linear relationships and outliers.

🔁 Cross-Validation Results (Random Forest)
To ensure model robustness, 5-fold cross-validation was applied on the Random Forest model:

R² per fold: [0.8274, 0.8334, 0.8374, 0.8166, 0.8230]
Average R²: 0.8276
This consistent performance across folds confirms the model's generalization capability.

🔍 Feature Importance
The following are the top 15 most important features contributing to the Random Forest model:

Visual plot shown in the notebook.

💾 Final Model Export
The final tuned Random Forest model was saved using joblib and can be loaded for deployment or inference:

import joblib
model = joblib.load('modelo_random_forest_tuned.pkl')


✅ Conclusion
This project demonstrates a complete data science pipeline:

Data exploration and cleaning

Feature selection and transformation

Training and evaluating multiple models

Improving performance through hyperparameter tuning

Visualizing insights and model interpretation

The final tuned Random Forest model provides reliable predictions with strong generalization, making it suitable for real-world deployment scenarios in real estate price estimation.
