- URL: https://www.projectpro.io/project-use-case/anomaly-detection-using-deep-learning-and-autoencoders

### Problem description

### Problem description from data science perspective

- To solve the problem I have used a credit card fraud dataset that represents fraudulent and legal transactions over a certain period of time.

- In the dataset that I have used, most of the column names (V1 to V28) are not mentioned explicitly because PCA (Principal Component Analysis) transformation has been perfomed on the original dataset to maintain the confidentiality of the data. Apart from these variables, we have the following variables:

  - Time - Difference in seconds between each transaction and its previous transaction

  - Amount - Transaction Amount

  - Class (0 - Non-fraudulent transaction) or (1 - Fraudulent Transaction)

### Theoretical description

Because not everyone is familiar with the Anomaly Detection approach and its numerous application in different industries, I've given a brief overview below to ensure that everyone can comprehend my solution to this problem.

**What is anomaly detection?**

**Anomaly detection** (aka outlier analysis) is a step in data mining that identifies data points, events, and/or observations that deviate from a dataset’s normal behavior. Anomalous data can indicate critical incidents, such as a technical glitch, or potential opportunities, for instance, a change in consumer behavior.

**Applications of Anomaly detection**

- _Banking, Financial Services, and Insurance (BFSI)_ – In the banking sector, some of the use cases for anomaly detection are to flag abnormally high transactions, fraudulent activity, and phishing attacks.

- _Retail_ – In Retail, anomaly detection is used for processing large volumes of financial transactions to identify fraudulent behaviors, such as identity theft and fraudulent credit card usage.

- _Manufacturing_ – In Manufacturing, anomaly detection can be used in several important ways, such as identifying machines and tools that are underperforming, which can take months to find without anomaly detection technology.

- _IT and Telecom_ – In IT and Telecommunications, anomaly detection is increasingly valuable to detect and act on personal threats to users, financial threats to service providers, or other types of unexpected threats.

- _Defense and Government_ – In the Defence and Government setting, anomaly detection is best used for identifying excessive and fraudulent government spending, budgeting, and audits. This can save governments an immense amount of money.

- _Healthcare_ – In Health Care, anomaly detection is used for its application in a crucial management task that can improve the quality of the health services and avoid loss of huge amounts of money. In terms of identifying fraudulent claims from hospitals and on the side of the insurance providers.

### Solution description
