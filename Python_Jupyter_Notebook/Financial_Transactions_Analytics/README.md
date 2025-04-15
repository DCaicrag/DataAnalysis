# 🧠 Fraud Detection & Customer Segmentation – Mobile Transactions (BankSim)

**Professional Data Science Project | Python | Classification & Clustering | SHAP Explainability**

This project simulates real-world fraud detection using the synthetic BankSim dataset, based on mobile financial transactions. It features a complete machine learning pipeline for identifying fraudulent behavior and segmenting customers, applying advanced data science practices with explainability tools.

---

## 📌 Project Objectives

- Perform advanced exploratory data analysis (EDA) on financial transactions
- Engineer behavior-based features and customer-level indicators
- Segment customers using clustering techniques (KMeans, DBSCAN)
- Detect fraud using classification models (Logistic Regression, Random Forest, XGBoost)
- Handle class imbalance with SMOTE and class weights
- Apply explainability techniques (SHAP) for model interpretation
- Evaluate models with real business metrics (Precision, Recall, F1, ROC-AUC)

---

## 🗂️ Dataset

**Source**: [BankSim – Synthetic Data](https://www.kaggle.com/datasets/edgarlopezguajardo/banksim)  
**Records**: ~594,000 financial transactions  
**Columns**: transaction type, amount, timestamp, customer/merchant IDs, fraud label  
**Nature**: Synthetic but statistically calibrated using real transaction patterns from a Spanish bank.

---

## 📁 Project Structure & Phases

### ✅ Fase 0 — Project Setup
- Dataset description
- Fraud detection context
- Evaluation metrics: Precision, Recall, F1-score, ROC-AUC

### ✅ Fase 1 — Preprocessing
- Dataset loading and format checks
- Null/duplicate validation
- Feature type conversion and log-transform for skewed values

### ✅ Fase 2 — Exploratory Data Analysis (EDA)
- Distribution by transaction type, gender, age
- Fraud distribution and behavior patterns
- Visualization of temporal fraud activity and amount distributions (log scale)

### ✅ Fase 3 — Feature Engineering
- Aggregated features per customer (mean, max, std of amounts)
- Time between transactions
- Transaction frequency and category diversity
- Log-transform for transaction amount
- Final diagnosis of newly created features

### ✅ Fase 4 — Customer Segmentation (Clustering)
- Feature selection and scaling
- Elbow method for optimal k
- KMeans clustering and PCA-based visualization
- Characterization of clusters for behavioral profiling

### ✅ Fase 5 — Class Imbalance Handling
- Class imbalance diagnosis (fraud < 1.5%)
- SMOTE resampling for minority class
- Optionally using `class_weight='balanced'` in models

### ✅ Fase 6 — Modeling
- Train/test split with stratification
- Model training: Logistic Regression, Random Forest, XGBoost
- Cross-validation (StratifiedKFold) with ROC-AUC as metric
- Performance comparison across models

### ✅ Fase 7 — Model Explainability (SHAP)
- Global feature importance (SHAP bar plot)
- Distribution impact (SHAP summary plot)
- Local explanation via waterfall plot

### ✅ Fase 8 — Final Results & Export
- Evaluation metrics on test set (Precision, Recall, F1, Confusion Matrix)
- ROC curve for model validation
- Export of final model (`.joblib`) for deployment

---

## 📊 Tools & Technologies

- **Languages**: Python (Jupyter Notebook)
- **Libraries**: pandas, numpy, matplotlib, seaborn, scikit-learn, imbalanced-learn, shap, xgboost
- **Machine Learning**: Random Forest, Logistic Regression, XGBoost, SMOTE
- **Explainability**: SHAP

---

## 🏁 Final Notes

This project simulates real-world fraud detection with a structured pipeline covering:
- Data understanding
- Behavioral modeling
- Predictive learning
- Explainability and business interpretation

---

## 📫 Contact

📧 danielcolingarcia@outlook.com  
🔗 [LinkedIn – Daniel Colín](https://www.linkedin.com/in/danielcolíngarcía)

---

🟣 *“Transforming data into decisions — one transaction at a time.”*
