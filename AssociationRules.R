#Load packages
library(arules)
library(arulesViz)

#Get the supermarket data
raw_data <- readLines("http://fimi.ua.ac.be/data/retail.dat")
head(raw_data)

#Split raw data at each line wherever there is a blank space character
list_data <- strsplit(raw_data, " ")

#Label individual transaction
names(list_data) <- paste("Trans", 1:length(list_data), sep="")
str(list_data)

#Convert list to 'transactions' object for arules package
trans_data <- as(list_data, "transactions")

#View summary
summary(trans_data)

#Finding association rules
rules <- apriori(trans_data, parameter=list(supp=0.001, conf=0.45))

#Visualizing the association rules
plot(rules)

#Find rules with high lift
high_lift <- head(sort(rules, by="lift"), 50)
inspect(high_lift)

#Plot graph to check for patterns 
plot(high_lift, method="graph", control=list(type="items"))

#Each circle there represents a rule with inbound arrows coming from items on the
#left-hand side of the rule and outbound arrows going to the right-hand side. The
#size (area) of the circle represents the rule's support, and shade represents
#lift (darker indicates higher lift)

##Combine information on item cost and margin with transaction data

#Compile a list of the item names
itemnames <- sort(unique(unlist(as(trans_data, "list"))))

#Generate the simulated margin data with one value for each item
margin_data <- data.frame(margin=rnorm(length(itemnames),
                                         mean=0.30, sd=0.30))
rownames(margin_data) <- itemnames

##Find the margin for a complete transaction (#1)

#Convert a transaction (#1) to list form to find the items in it
basket_items <- as(trans_data[1], "list")[[1]]
margin_data[basket_items, ]
sum(margin_data[basket_items, , ])