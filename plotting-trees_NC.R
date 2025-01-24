# Plotting phylogenies in R
# 
# Remember to install ape and ggtree
# For ggtree:
# install.packages("BiocManager")
# BiocManager::install("ggtree")

# load libraries
library(ape) # for reading in and plotting trees
library(ggtree) # for plotting trees
library(tidyverse) # for plotting functions in ggplot

# Read in the basic tree
mytree <- read.tree("data/basic.tre")

#-----------------
# APE
#-----------------

# Look at the tree summary
mytree

# Look at the tree structure
str(mytree)

# Plot the tree
plot(mytree)

# Read in the bird orders tree
bird.orders <- read.tree("data/bird.orders.tre")

# Plot the bird orders tree
plot(bird.orders)

# Plot the tree as a circular/fan phylogeny with small labels
plot(bird.orders, 
     cex = 0.6, 
     type = "fan", 
     no.margin = TRUE)

# Change the colours of the branches and tips
plot(bird.orders, 
     edge.color = "deeppink", 
     tip.color = "springgreen", 
     no.margin = TRUE)

#---------------------
# Adding data to trees
#---------------------
# Read in some data (in reality something you've collected, 
# here some invented facts) 
birds <- read.csv("data/birds-facts.csv")
# look at it!
str(birds)

# Choose three colours for the plot
mycolours <- c("gold", "cornflowerblue", "cyan4")

# Plot the tree
plot(bird.orders, label.offset = 2, cex = 0.8, no.margin = FALSE)
# Add the squares at the tip labels.
# Colours are taken from mycolours, and selected based on level of 
# coolness from the birds dataset
tiplabels(pch = 22, bg = mycolours[as.factor(birds$coolness)], 
          cex = 1.2, adj = 1)
# Add a legend
legend("topright", fill = mycolours, 
       legend = c("Awesome", "Cool", "OK"), bty = "n")

#------------------------------------------------------------
### BEWARE ### 
# This is a silly example where it doesn't matter but if using your own data
# this only works in the data are IN THE SAME ORDER as the tip labels
# You can make sure of this using this bit of code

birds <- birds[match(bird.orders$tip.label, birds$orders), ]
#------------------------------------------------------------
# We can also plot continuous data 
plot(bird.orders, label.offset = 2, cex = 0.8, no.margin = FALSE)
# Add the squares at the tip labels.
# Colours are taken from mycolours, and selected based on level of 
# coolness from the birds dataset
tiplabels(pch = 23, bg = birds$footsize, 
          cex = 1.2, adj = 1)

#--------------
# ggtree
# --------------

# Basic plot
ggtree(mytree)

# Add tip labels
ggtree(mytree) +
# Add tip labels as text, slightly offset from the tips and aligned
geom_tiplab()

# oops the tip labels don't fit! And they're really close to the tips
# Change x limits so the tip labels fit
ggtree(mytree) +
  # Change x limits
  xlim(0, 22) +
  # Add an offset so there's a gap between the tree and names
  geom_tiplab(offset = 1, fontface = "italic")

# With a time scale
ggtree(mytree) + theme_tree2()

# With blue dashed branches
ggtree(mytree, color = "blue", 
       size = 2, linetype = 2)

# With coloured tip points and node points
ggtree(mytree) +
geom_nodepoint(colour = "coral", shape = "square",
               alpha = 0.8, size = 5) +
  geom_tippoint(size = 2, colour = "cyan3")

# Add node numbers
ggtree(mytree) + 
geom_text(aes(label = node), 
          hjust = -0.3)

#######################################
# EXERCISE
# Use ggtree to plot the bird.orders tree
ggtree(bird.orders) +
  geom_tiplab(offset = 1) +
  xlim(0, 50)

# Can you plot it as a circular phylogeny?
ggtree(bird.orders, layout = "fan") +
  geom_tiplab(offset = 1) +
  xlim(0, 50)

# Can you plot it as a slanted phylogeny with orange dotted lines?
ggtree(bird.orders, layout = "slanted", colour = "orange", linetype = "dotted") +
  geom_tiplab(offset = 1) +
  xlim(0, 50)

# Can you add big purple diamonds at the nodes, and small yellow crosses at the tips?
ggtree(bird.orders) +
  geom_tiplab(offset = 1) +
  xlim(0, 50) +
  geom_tippoint(colour = "yellow", shape = "cross") +
  geom_nodepoint(colour = "purple", shape = "diamond", size = 4, alpha = 0.8)

#------------------------------
# Labeling/highlighting clades
# -----------------------------

# Plot tree with clades highlighted or labelled
ggtree(mytree) + 
  # Change limits so labels fit
  xlim(0, 22) +
  # Add tip labels
  geom_tiplab() +
  # Highlight clades
  geom_hilight(node = 6, fill = "cornflowerblue", alpha = 0.4) +
  geom_hilight(node = 7, fill = "springgreen", alpha = 0.4) +
  # Add labels
  geom_cladelabel(node = 7 , label = "A", offset = 3,
                  fontsize = 5) +
  geom_cladelabel(node = 6 , label = "B", offset = 5,
                  fontsize = 5)

# You can also highlight non-monophyletic groups using groupOTU. 
# Here’s a quick and silly example…

# Define group
feathers <- list(no   = c("deer","jellyfish", "spider"),
                 yes = c("robin"))

# Plot and save as an object called "p"
p <- 
  ggtree(mytree) + 
  # Change limits so labels fit
  xlim(0, 25) +
  # Add tip labels
  geom_tiplab()

# Add colours to branches and labels
groupOTU(p, feathers, 'feathers') + 
  aes(color = feathers) +
  scale_colour_manual(values = c("orange1","darkblue")) +
  theme(legend.position = "top")

#-------------------------
# Adding pictures to tips
# ------------------------
# Load library
library(ggimage)

ggtree(mytree) + 
  xlim(0, 22) +
  # Add tip label pictures
  geom_tiplab(aes(image = c("images/deer.png",
                            "images/robin.png",
                            "images/spider.png",
                            "images/jellyfish.png",
                            rep(NA, 3))), 
              geom = "image", align = TRUE, offset = 0.5, 
              linetype = NA, size = c(0.12, 0.15, 0.09, 0.15))

#----------------------------------
# Adding data to plots with facets
# ---------------------------------

# Plot tree and save it as "p"
p <- ggtree(bird.orders)
# Look at it
p

# Make a second plot naming the new panel "footsize", 
# using the footsize, with a point geom and coloured by coolness.
# call this "p1"
p1 <- facet_plot(p, panel = "footsize", data = birds, geom = geom_point, 
         aes(x = footsize, colour = coolness))
# look at it
p1

# Now add to that second plot we'll save as "p2"
# This time showing a bar segment, size 3, coloured by coolness
p2 <- facet_plot(p1, panel = 'vibe', data = birds, geom = geom_segment, 
                 aes(x = 0, xend = vibe, y = y, yend = y, colour = coolness), size = 3) 
# look at it
p2

# Show all three plots with a scale
p2 + theme_tree2()

#----------------------------------
# Adding data to plots as heat maps
#----------------------------------
# NOTE: these plots will give error messages:
# Scale for fill is already present.
# Adding another scale for fill, which will replace the existing scale.

# Don't worry - it's just making it clear to you that you've changed
# the scale by defining colours etc.
# ---------------------------------
# Create a new dataframe object that
# contains only the variable you want to plot
# with the species/tip names as rownames...
feet <-
  birds %>%
  select(footsize) %>%
  as.data.frame()
# Add rownames as species names  
rownames(feet) <- birds$orders

# Look at this
feet

# Make the circular tree base
circ <- ggtree(bird.orders, layout = "circular")
# Look at it
circ

# Add the heatmap of feet to the circ tree
# offset = move away from tips of tree
# width = the width of the coloured bar
  gheatmap(circ, feet, offset =.8, width =.2, colnames = FALSE) +
# add fill colours using the viridis colour scale (plasma option), 
# with continuous data (scale_fill_viridis_c) [use scale_fill_viridis_d for discrete data]
# use grey for NAs if there are any
# Add "foot size (cm)" to the legend title
  scale_fill_viridis_c(na.value = "grey90", option = "plasma", name = "foot size (cm)")

# see ?scales::viridis_pal for options of palettes other than plasma

# ---------------------------------
# Another example
# ---------------------------------   
# Create a new dataframe object that
# contains only the variable you want to plot
# with the species/tip names as rownames...
cool <-
    birds %>%
    select(coolness) %>%
    as.data.frame()
  # Add rownames as species names  
  rownames(cool) <- birds$orders

# Make the rectangular tree base
base <- ggtree(bird.orders)
# Look at it
base

# Add the heatmap of cool to the base tree
# offset = move away from tips of tree
# width = the width of the bar
# You can add the variable name at the top of the column
# Here I've done this with font size 4, and the names on top 
# (you can move them to the bottom)
gheatmap(base, cool, offset = 12, width = 0.2,
           font.size = 4, colnames_position = "top", color = "black")+
  geom_tiplab() +
# add fill colours using standard scale fill manual
  scale_fill_manual(values = c("gold", "cornflowerblue", "cyan4")) +
  theme(legend.title = element_blank())

# Note you might have to fiddle with the offsets 
# and widths etc to make this look nice
# ---------------------------------
# An example with two traits...
# ---------------------------------
# This needs another package: ggnewscale
library(ggnewscale)

# Make the first plot and give it a name, here "cool_plot"
cool_plot <- 
  gheatmap(base, cool, offset = 12, width = 0.2,
         font.size = 3, colnames_position = "top", color = "black")+
  geom_tiplab() +
  # add fill colours using standard scale fill manual
  scale_fill_manual(values = c("gold", "cornflowerblue", "cyan4")) +
  theme(legend.title = element_blank())

# Now tell ggtree to add another plot but remove the existing scale
# Give this a name too - here I called in cool_plot2
cool_plot2 <- cool_plot + new_scale_fill()

# Now add the second heatmap
# Make sure the offset is bigger than the first one so it plots
# next to the first one - this might need a bit of fiddling to get right
gheatmap(cool_plot2, feet, offset = 18, width = 0.2,
         font.size = 3, colnames_position = "top", color = "black") +
  scale_fill_viridis_c(na.value = "grey90", option = "plasma", name = "foot size (cm)")

# This will also work with circular phylogenies 

# More ideas: https://yulab-smu.top/treedata-book/chapter7.html