# Some code to create a hex sticker
#
# Jason D. Everett (UQ/CSIRO/UNSW)

# For installation instructions see here:
# https://github.com/GuangchuangYu/hexSticker

# devtools::install_github("GuangchuangYu/hexSticker")

library(ggplot2)
p <- ggplot() +
  geom_text(aes(x = 0, y = 0, label = "<*)))><"), size = 35, colour = "white") +
  theme_void() +
  theme(panel.background = element_rect(fill = "transparent", colour = NA),
        plot.background = element_rect(fill = "transparent", colour = NA))

hexSticker::sticker(p,
        package = "utils4mme",
        p_size = 20,
        # p_y = 1.7,
        p_color = "white",
        s_x = 1,
        s_y = 0.8,
        s_width = 5,
        s_height = 2,
        h_fill = "black",
        h_color = "white",
        url = "https://mathmarecol.github.io",
        u_size = 5,
        u_color = "white",
        filename="man/figures/MME_Hex.png")
