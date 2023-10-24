
# code to plot the startle circuit

rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
gc() #free up memory and report the memory usage.
Sys.setenv('R_MAX_VSIZE'=8000000000)

library(catmaid)
library(dplyr)
library(tibble)
library(tidyr)
library(RColorBrewer)

#for the public server:
conn_http1 <- catmaid_login(
  server="https://catmaid.jekelylab.ex.ac.uk/", 
  authname="AnonymousUser",
  config=httr::config(ssl_verifypeer=0, http_version=1)
)

Okabe_Ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", 
               "#CC79A7", "#000000")
oranges <- brewer.pal(9, 'YlOrRd')

# functions ----------

#plotting function for ventral view with yolk and acicula
plot_background_ventral_no_acic <- function(x){
  nopen3d() # opens a pannable 3d window
  par3d(windowRect = c(20, 30, 600, 800)) #to define the size of the rgl window
  nview3d("ventral", extramat=rotationMatrix(0, 1, 0, 0))
  plot3d(yolk, WithConnectors = F, WithNodes = F, soma=F, lwd=2,
         rev = FALSE, fixup = F, add=T, forceClipregion = F, alpha=0.05,
         col="#E2E2E2") 
  par3d(zoom=0.58)
}

# read volumes and neurons ------------------

yolk <- catmaid_get_volume(4, rval = c("mesh3d", "catmaidmesh", "raw"),
                           invertFaces = T, conn = NULL, pid = 11)


CR <-   nlapply(read.neurons.catmaid("^CRneurons$", pid=11),
                     function(x) smooth_neuron(x, sigma=6000))
INCM <-   nlapply(read.neurons.catmaid("^celltype60$", pid=11),
                function(x) smooth_neuron(x, sigma=6000))
INsplitCR <-   nlapply(read.neurons.catmaid("^celltype73$", pid=11),
                  function(x) smooth_neuron(x, sigma=6000))
INsplitCRATO <-   nlapply(read.neurons.catmaid("^celltype74$", pid=11),
                       function(x) smooth_neuron(x, sigma=6000))
INarc1 <-   nlapply(read.neurons.catmaid("^celltype55$", pid=11),
                    function(x) smooth_neuron(x, sigma=6000))
INrope <-   nlapply(read.neurons.catmaid("^celltype58$", pid=11),
                    function(x) smooth_neuron(x, sigma=6000))
Loop <-   nlapply(read.neurons.catmaid("^celltype59$", pid=11),
                    function(x) smooth_neuron(x, sigma=6000))
MNant <-   nlapply(read.neurons.catmaid("^celltype19$", pid=11),
                  function(x) smooth_neuron(x, sigma=6000))
MNcrab <-   nlapply(read.neurons.catmaid("^celltype65$", pid=11),
                   function(x) smooth_neuron(x, sigma=6000))
MNbiramous <-   nlapply(read.neurons.catmaid("^celltype63$", pid=11),
                   function(x) smooth_neuron(x, sigma=6000))
MNspider_post <-   nlapply(read.neurons.catmaid("^celltype62$", pid=11),
                   function(x) smooth_neuron(x, sigma=6000))
MNspider_ant <-   nlapply(read.neurons.catmaid("^celltype61$", pid=11),
                   function(x) smooth_neuron(x, sigma=6000))



# read effectors --------------------------

ciliomot_skids <- c(names(Loop), names(MNant))
ciliomot_partners <- catmaid_get_connector_table(ciliomot_skids, pid = 11)
musmotor_skids <- c(names(MNcrab), names(MNbiramous), names(MNspider_ant), names(MNspider_post))
musmotor_partners <- catmaid_get_connector_table(musmotor_skids, pid = 11)

ciliomot_partners_post <- ciliomot_partners %>%
  filter(direction == "outgoing") %>%
  pull(partner_skid) %>% unique()
musmotor_partners_post <- musmotor_partners %>%
  filter(direction == "outgoing") %>%
  pull(partner_skid) %>% unique()

ciliomot_partners_post_troch <- bind_rows(catmaid_get_neuronnames(ciliomot_partners_post, pid = 11)) %>%
  pivot_longer(everything(), names_to = "skid", values_to = "name") %>%
  filter(grepl('troch', name)) %>%
  pull(skid)
musmotor_partners_post_MUS <- bind_rows(catmaid_get_neuronnames(musmotor_partners_post, pid = 11)) %>%
  pivot_longer(everything(), names_to = "skid", values_to = "name") %>%
  filter(grepl('MUS', name)) %>%
  pull(skid)

ciliomot_partners_post_troch_n <- nlapply(read.neurons.catmaid(ciliomot_partners_post_troch, pid=11),
                                          function(x) smooth_neuron(x, sigma=6000))
musmotor_partners_post_troch_n <- nlapply(read.neurons.catmaid(musmotor_partners_post_MUS, pid=11),
                                          function(x) smooth_neuron(x, sigma=6000))


# get basal bodies -----------------

#read all nodes
ciliomot_partners_post_troch_nodes <- lapply(
  ciliomot_partners_post_troch, 
  function(x) catmaid_get_treenode_table(x, pid = 11)
)

#get tags
tags_with_id <- lapply(ciliomot_partners_post_troch_nodes, function(x) 
  catmaid_get_labels(treenodes = x$id, pid = 11))

#select basal body tags
bb_nodes_id <- lapply(tags_with_id, function(x) x %>%
                        as_tibble() %>%
                        filter("basal body" == label) %>%
                        select(id) %>%
                        pull()
)

#ids of nodes with bb tag
bb_nodes_id <- unlist(bb_nodes_id)
#coordinates
bb_xyz <- lapply(ciliomot_partners_post_troch_nodes, function(k) k %>%
                   as_tibble() %>%
                   filter(id %in% bb_nodes_id) %>%
                   select(x,y,z)
)


# 3d plotting ---------------

plot_background_ventral_no_acic()
plot3d(CR, soma = TRUE, lwd = c(2,5), add = T, alpha = 1, col = oranges[7])
plot3d(INCM, soma = TRUE, lwd = c(2,5), add = T, alpha = 1, col = Okabe_Ito[2])
plot3d(INsplitCR, soma = TRUE, lwd = c(2), add = T, alpha = 1, col = Okabe_Ito[5])
plot3d(INsplitCRATO, soma = TRUE, lwd = c(5), add = T, alpha = 1, col = Okabe_Ito[5])
plot3d(INarc1, soma = TRUE, lwd = c(4), add = T, alpha = 1, col = Okabe_Ito[5])
plot3d(INrope, soma = TRUE, lwd = c(6), add = T, alpha = 1, col = Okabe_Ito[8])

plot3d(Loop, soma = TRUE, lwd = c(2), add = T, alpha = 1, col = Okabe_Ito[6])
plot3d(MNant, soma = TRUE, lwd = c(3), add = T, alpha = 1, col = Okabe_Ito[7])
plot3d(MNcrab, soma = TRUE, lwd = c(2), add = T, alpha = 1, col = Okabe_Ito[6])
plot3d(MNbiramous, soma = TRUE, lwd = c(2), add = T, alpha = 1, col = Okabe_Ito[7])
plot3d(MNspider_ant, soma = TRUE, lwd = c(2), add = T, alpha = 1, col = Okabe_Ito[6])
plot3d(MNspider_post, soma = TRUE, lwd = c(4), add = T, alpha = 1, col = Okabe_Ito[7])

plot3d(ciliomot_partners_post_troch_n, add = TRUE, alpha = 1, lwd = 3, 
         soma = TRUE, col = "grey95"
       ) 
lapply(bb_xyz, function(x) 
    plot3d(
      x, 
      add = TRUE, 
      size = 2, alpha = 1, 
      col = Okabe_Ito[5])
    )

plot3d(musmotor_partners_post_troch_n, add = TRUE, alpha = 0.7, lwd = c(1,2,3), 
       soma = TRUE, col = oranges[2:5]
) 

# export frames ------------------------

um1 <- par3d()$userMatrix
rotation <- 100
for (l in 1:180){
  #rotate in a loop (with l e.g. 1:90 for a 180 turn)
  nview3d(userMatrix = um1 %*%rotationMatrix(pi*l/90, 0, 0, 1))
  print (l)
  #save a snapshot
  filename <- paste("./movies/frames/Video31_",
                    rotation,
                    formatC(l, digits = 2, flag = "0"),
                    ".png", sep = "")
  rgl.snapshot(filename)
  rotation = rotation + 1 
}


close3d()

#read png files and write video
av::av_encode_video(paste('movies/frames/', list.files("movies/frames/", '*.png'), sep = ""), 
                    framerate = 10,
                    output = 'movies/Video_startle.mp4')

unlink("movies/frames/", recursive = T)



