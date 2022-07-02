
# group information
groupvs <- function(vsinfo) {
    return(unique(vsinfo$group))
}

# Z-score
statZS <- function(dat, vsinfo, cont_label="control", case_label="DOX"){
    # sample information
    group <- vsinfo[vsinfo$group%in%c(cont_label, case_label), ]
    cont <- vsinfo[vsinfo$group%in%cont_label, ]
    case <- vsinfo[vsinfo$group%in%case_label, ]
  
    # expression
    contExpr <- dat[, cont$sample]
    caseExpr <- dat[, case$sample]
    # z-score based on control samples
    contZS <- sweep(sweep(contExpr, 1, apply(contExpr, 1, mean), FUN="-"), 1, apply(contExpr, 1, sd), FUN="/")
    caseZS <- sweep(sweep(caseExpr, 1, apply(contExpr, 1, mean), FUN="-"), 1, apply(contExpr, 1, sd), FUN="/")
    # description
    contZS$Group <- cont_label
    contZS$Meta <- rownames(contZS)
    
    caseZS$Group <- case_label
    caseZS$Meta <- rownames(caseZS)
    
    caseZS <- melt(caseZS, id.vars = c("Group", "Meta"))
    contZS <- melt(contZS, id.vars = c("Group", "Meta"))
    # Factor
    zsExpr <- rbind(caseZS, contZS)
    zsExpr$Meta <- factor(x = zsExpr$Meta, levels = unique(zsExpr$Meta[order(zsExpr$value)]))
    zsExpr$Group <- factor(x = zsExpr$Group, levels = c(case_label, cont_label))

    # colnams
    colnames(zsExpr) <- c("Group", "Metabolite", "Sample", "ZScore")

    # return result
    return(zsExpr)
}



MetaZS <- function(zsExpr, cont_label="control", case_label="DOX", 
                   str_len = 18, txt_size = 12, point_size = 2, 
                   h = 18, w = 18){
   
    # plot figure
    p <- ggplot(data=zsExpr, aes(x = ZScore, y = Metabolite, color = Group)) +
      geom_point(
        size = point_size,
        alpha = 0.6,
        shape = 16
      ) +
      scale_x_continuous(
        name = "Z-Score",
        limits = c(floor(min(zsExpr$ZScore)), ceiling(max(zsExpr$ZScore))),
        breaks = seq(floor(min(zsExpr$ZScore)), ceiling(max(zsExpr$ZScore)), length.out=5),
        labels = seq(floor(min(zsExpr$ZScore)), ceiling(max(zsExpr$ZScore)), length.out=5)
      ) +
      scale_color_manual(
        breaks = c(cont_label, case_label),
        values = c("#99CCFF", "#FF66CC")
      )+
      theme_prism() +
      theme(
        axis.title.y = element_blank()
      )
    
      p <- p + scale_y_discrete(
        breaks = unique(zsExpr$Metabolite),
        labels = str_wrap(unique(zsExpr$Metabolite), str_len)
      ) 
    
    # Result
    return(p)
}




# MetaZS(dat = dat, vsinfo = vsinfo, point_size = 6)
