set.seed(42)

mydata<-
  data.frame(x=rnorm(30),
             y=rnorm(30))
library(ggplot2)

# my version
ggplot(mydata,
       aes(x, y))+
  geom_point(shape = 23,  # Diamond shape
             color = "black",  # Border color
             fill = "pink",   # Fill color
             alpha = 0.75,     # Transparency
             size = 5)+
  labs(x="happy",
       y="excited", 
       title = "I love Chat GPT")+
  theme_bw()+
  theme(axis.title.x = element_text(color = "red", angle = 45),  # Red x-axis label at 45 degrees
        axis.title.y = element_text(color = "blue", size = 16)  # Blue y-axis label with size 16
        )

# chatGPT conversion to base r
# Create the plot
plot(mydata$x, mydata$y,
     pch = 23,                               # Diamond shape
     bg = rgb(1, 0.75, 0.8, 0.5),            # Transparent pink fill
     col = "pink",                           # Border color
     cex = 1.5,                              # Point size
     xlab = "",                              # Leave x-axis label blank for now
     ylab = "",                              # Leave y-axis label blank for now
     main = "I love Chat GPT")               # Title

# Add customized x-axis label
mtext("happy", side = 1, line = 3, col = "red", las = 2, adj = 1)

# Add customized y-axis label
mtext("excited", side = 2, line = 3, col = "blue", cex = 1.6)
