library(cluster)
library(factoextra)
library(reshape2)
library(skimr)
library(tidyverse)

###############
# 1: LOADING AND CHECKING DATA
###############
#load tidyverse and the data
phone <-read.csv("dataset.csv")
phone

skim(phone)
#From skim we see no missing value in this dataset, as well as outliers in 'Time owned current phone'

#Remove outliners, keep the 99.9% quantile (1 record removed)
phone <- phone%>%
    filter(Time.owned.current.phone < quantile(Time.owned.current.phone,0.999))
skim(phone)


###############
# 2.1 K-MEANS CLUSTERING: Data cleansing
###############
#Since K-mean does not work on categorical data, I need to change them to dummy variables

#Let's look at gender first
phone %>%
    group_by(Gender) %>%
    summarise(n = n())

#Introduce two binary variables: 0 female, 1 male
#Assign a new 'male' variable
phone <- mutate(phone, 
                male = ifelse(phone$Gender == "male", 1, 0),
                .after = 'Gender')
#Check it's been added
phone

#Let's look at Smartphone
phone %>%
    group_by(Smartphone) %>%
    summarise(n = n())

phone <- mutate(phone, 
                iPhone = ifelse(phone$Smartphone == "iPhone", 1, 0),
                .after = 'Smartphone')
#Check it's been added
phone

skim(phone)


###############
# 2.2 STANDARDISATION
###############

#Standardise data for clustering
phone_z <- phone %>% 
    select(-c(Smartphone,Gender)) %>% #we select only numerical data 
    scale() #feature scaling

###############
# 2.3 RUNNING K-MEANS
###############

#Identify optimal number for k using series of methods via fviz_nbclust
#elbow test
fviz_nbclust(phone_z, kmeans, method = "wss")+ labs(subtitle = "Elbow method")
#Silhouette test
fviz_nbclust(phone_z, kmeans, method = "silhouette")+ labs(subtitle = "Silhouette method")


#Run kmeans
set.seed(123)
phone.kmeans <- kmeans(phone_z, 2)


###############
# 2.4 EVALUATE OUTPUT
###############

# look at the size of the clusters
#Cluster 1 - 272, Cluster 2 - 256
phone.kmeans$size

# look at the cluster centers
phone.kmeans$centers

# apply the cluster IDs to the original data frame
phone$cluster <- phone.kmeans$cluster

# look at the first five records
phone[1:5, c("cluster","Gender","Age")]

# mean age by cluster
#Cluster 2 older, Cluster 1 younger
aggregate(data = phone, Age ~ cluster, mean)

# proportion of male by cluster
#Cluster 1: 17% male, Cluster 2: 47% male 
aggregate(data = phone, male ~ cluster, mean)

# proportion of iPhone by cluster
#Cluster 1:83% is iPhone user
aggregate(data = phone, iPhone ~ cluster, mean)


##Explore the centres
centers <- melt(data.frame(cluster = 
                               rownames(phone.kmeans$centers), phone.kmeans$centers))
centers

#Let's make a simple plot of the centers
#Note: stat = "identity" overrides the default bar chart statistic of "count"
ggplot(centers, aes(x = reorder(variable, value), y = value)) +
    geom_bar(aes(fill = value > 0), width=0.8, stat = "identity") +
    facet_wrap(~ cluster, nrow=1) +
    coord_flip() +
    theme_bw() +
    theme(panel.border = element_rect(colour = "black", fill=NA), 
          legend.position="none") +
    labs(x = NULL)

#A negative z-score reveals the raw score is below the mean average. For example, if a z-score is equal to -2, it is 2 standard deviations below the mean. 
#Cluster 1 is probably female iPhone users who see phone as a status. They also have a higher emotionality than average and consists of a lower age group.
#Clsuter 2 probably has a higher age group, they generally do not see phone as a status and has an averagely higher index in all 6 personalities.


#Visualize clusters within convex space
fviz_cluster(phone.kmeans, data = phone_z, 
             ellipse.type = "convex", palette = "jco", 
             ggtheme = theme_minimal())


#Insight extraction by the clusters
#Scatter Plot: Phone as status object VS Honesty-Humility
ggplot(phone, aes(Honesty.Humility,Phone.as.status.object)) +
    geom_point(aes(color = as.factor(cluster)))+
    geom_smooth(method = "lm")+
    labs(y = "Phone as status object", x="Honesty-Humility", title = "Phone as status object VS Honesty-Humility", color = "cluster")

#Scatter Plot: Honesty-Humility VS Age
ggplot(phone, aes(Honesty.Humility,Age)) +
    geom_point(aes(color = as.factor(cluster)))+
    geom_smooth(method = "lm")+
    labs(y = "Age", x="Honesty-Humility", title = "Honesty-Humility VS Age", color = "cluster")


###############
# 2.5 MODEL EVALUATION
###############
#Model Evaluation
phone_sil<-silhouette(phone.kmeans$cluster, get_dist(phone_z, method = "euclidean"))
fviz_silhouette(phone_sil, ylim = c(-0.1,0.4))
