Credit Risk Prediction Project Dataset Source: Kaggle - Credit Card Approval Prediction

📌 Project Overview The goal of this project is to build a reliable credit risk classification model capable of predicting whether a client is likely to be classified as a high-risk borrower. The project uses real-life inspired data simulating credit card applications and historical credit behavior.

This project is focused on: Full data analysis workflow Feature engineering Class imbalance handling Model training, tuning and comparison Model interpretation

📊 Dataset The dataset contains:

application_record.csv: Socio-demographic and financial information of clients. credit_record.csv: Historical credit payment records. Merged dataset includes: ~36,000 clients. Variables such as gender, income, employment duration, education, housing, number of children, and credit history. Target variable: risk_label (0 = Low Risk, 1 = High Risk) created based on credit behavior.

💡 Workflow Overview Data Cleaning & Preprocessing: Missing values handling.

Feature engineering (age, employment seniority, family size). Creation of target variable (risk_label) based on credit history. Exploratory Data Analysis (EDA): Distributions and relationships of key variables. Insights into credit behavior patterns by risk group. Correlation matrix.

Feature Encoding: One-hot encoding for categorical variables. Numerical transformations.

Class Imbalance Handling: Applied SMOTE to balance classes due to very low proportion of high-risk clients (~0.8%).

Modeling & Evaluation: Trained, evaluated and compared: Logistic Regression (Baseline) Random Forest (Tuned - Fast Version) XGBoost (Tuned)

Threshold Tuning: Manual threshold adjustment to improve recall and balance.

⚙ Models & Results Model Precision Recall F1-score Logistic Regression ~1.1% ~25% ~2% Random Forest Tuned (Fast) 10.3% 30.0% 15.3% XGBoost Tuned ~7.6% 53.3% ~13%

✨ Final Choice: We selected Random Forest Tuned (Fast) as the final model due to:

The best compromise between precision and recall. A significantly higher F1-score. Faster training time compared to XGBoost with similar recall.

📈 Visualizations: Distribution of clients by risk. Feature importance analysis. Confusion matrices. Model performance comparison charts.

🧰 Technologies Used: Python Pandas, Numpy Scikit-learn XGBoost Imbalanced-learn (SMOTE) Seaborn, Matplotlib Jupyter Notebook

✅ Files Delivered: notebook_credit_risk_analysis.ipynb: Full project notebook. random_forest_tuned_fast.pkl: Final trained model. README.md: This documentation.

💡 Key Learning Outcomes: Handling of class imbalance in credit risk prediction. Training and tuning of multiple classification models. Threshold tuning for risk-sensitive problems. Professional-level model evaluation and selection.
