# A clustering (unsupervised machine learning) model that aims to understand naturally occurring clusters among Smartphone users. 
* Written by: [Ivy Wu S.Y.](https://www.linkedin.com/in/ivy-wusumyi)
* Technologies: R, tidymodels, clustering, K-means clustering



## 1. Introduction
Clustering is an unsupervised machine learning method that aims to uncover subpopulation structures in the data. This analysis helps us to gain a deeper understanding of naturally occurring clusters among Smartphone users.


## 2. About the Data
The data contains demograpgics and personality data from a variety of Apple and Android users (n=529). These data contain the following variables:
| Variable       |                |
| -------------- | -------------- |
| Smartphone(OS) | iPhone/ Android|
| Gender         | Female/ Male   |
| Age            |                |
| Personality(HEXACO) | Honesty-Humility<br>Emotionality<br>Extraversion<br>Agreeableness<br>Conscientiousness<br>Openness|
|Avoidance Similarity||
|Phone as status object||
|Socioeconomic status||
|Time owned current phone (months)||


## 3. Methodology: K-means Clustering
Considering a moderate size of dataset with 528 data points, the hierarchical clustering is generally not applicable to visualize the final output and rarely provides the best solution. As such, a K-means algorithm will be implemented to partition all observations into k clusters.  The flow diagram illustrates the general idea of how observations are assigned to clusters.<br/>
<img src="/images/method.png?raw=true" width="550"><br/>
To process the learning data, the two categorical variables (“Gender” and “Smartphone”) are converted into dummy variables. Considering the K-means algorithm uses distance-based measurement to determine similarity between clusters, the data is hence standardized to prevent larger scales variables from dominating how clusters are defined. 

## 4. Deciding Optimal Number of Clusters
The number of clusters (k) is the only parameter to be decided before running the model. Although there is no definitive answer, the optimal number of clusters can be determined by the Elbow test and Silhouette test as illustrated below. <br/>

1. Elbow Test<br/>
The Elbow method looks at the total intra-cluster variation as a function of the number of clusters, in which the location of a bend (elbow) in the plot is considered an indicator of the number of clusters. As indicated in below figure, however, the curve of total intra-cluster variation does not show a clear bend, of which 2 or 4 clusters might be appropriate for this dataset. <br/> 
<img src="/images/elbow.png?raw=true" width="550"> <br/>

2. Silhouette test<br/>
Since the elbow test does not give a precise result, an alternative method is used to determine the optimal number of clusters. The Silhouette method examinates how well each observation lies within its cluster by calculating the average silhouette width over a range of possible values of k. As illustrated in below figure, the method suggests 2 clusters with a maximum average width of 1.1.<br/> 
<img src="/images/silhouette.png?raw=true" width="550"> <br/>

## 5. Model Interpretation
With all things considered, a K-means clustering model is run with 2 clusters generated.<br/>
<img src="/images/cluster.png?raw=true" width="550"><br/>
<img src="/images/cluster_result.png?raw=true" width="350"><br/>

The result shows that Cluster 1 and Cluster 2 consists of 272 and 256 observations respectively. The table shows a summary of key features of two clusters, of which Cluster 1 is generally younger than that of Cluster 2 with a mean age of 22.65. Cluster 1 also dominates with 82% of female and 80% of iPhone users. Conversely, Clusters 2 shows a mean age of 35.23 whereas the proportion of male and female is roughly equally distributed. There are more Android users in Cluster 2 with a proportion of 64%. <br/>

To analyze further beyond the basic features, a bar chart diagram is created to understand the center of both clusters. A negative score reveals the raw score is below the mean average, and vice versa.<br/>
<img src="/images/barchart_cluster.png?raw=true" width="550"><br/>

To begin with, Cluster 1 generally consists of young female iPhone users who have a higher emotionality. They usually see iPhone as a status symbol and the time owned of current phone is short. Although 80% of them are iPhone users, their social-economic status is lower than average. Those youngsters may be mainly students who do not have a high income or social standing. While the immaturity of the group may result in a lower index of the rest of the personality variables such as a lower degree of honesty-humility and openness. In contrast, Cluster 2 contains more Android users who are from a higher age group. They do not see the phone as a status object and generally have a higher social-economic status. As expected, all personality indicators are positive with only emotionality being lower than the average. A scatter plot below shows an example of personality (Honesty-Humility) versus age, with a trend of higher age group tends to have a higher index.
<img src="/images/honesty_vs_age.png?raw=true" width="550"><br/>

## 6. Performance Evaluation 
Since clustering is a form of unsupervised learning and does not contain labels to identify the “correct” cluster, the evaluation of clustering is hence based on similarity or dissimilarity distance measured between clusters. The Silhouette coefficient indicates a score for each sample bounded between -1 for incorrect clustering and +1 for highly dense clustering. As indicated in below figure, the average score of clustering is 0.11, indicating the clusters generated are not highly separated. <br/> 
<img src="/images/clusters_silhouette.png?raw=true" width="550"><br/> 


## 6. Limitations of Random Forest Classification:
1.	Different initial partitioning can lead to a different clustering result.
2.	The algorithm assumes data is spherical and does not work well with clusters of varying sizes and densities.
3.	The algorithm is not robust to outliers and often difficult to predict the k value.


### To learn more about Ivy Wu S.Y., visit her [LinkedIn profile](https://www.linkedin.com/in/ivy-wusumyi)

All rights reserved 2022. All codes are developed and owned by Ivy Wu S.Y..