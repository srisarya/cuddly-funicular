set.seed(42)

mydata<-
  data.frame(x=rnorm(30),
             y=rnorm(30))
library(ggplot2)
ggplot(mydata,
       aes(x, y))+
  geom_point()+
  labs(x="happy",
       y="excited", 
       title = "I love Chat GPT")
