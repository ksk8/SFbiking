plot.map <- function(t, x, y) {
  plot(x = x, y = y, cex = 10,
       asp = 1, xlim = c(0, 150), ylim = c(0, 200),
       xlab = 'Horizontal displacement', ylab = 'Height', bty = 'l',
       main = 'A projectile', sub = 'Position over time')
  text(x = x, y = y, label = paste0('t=', t))
}

# png('projectile-single-position.png',
#     width = 900, height = 450)
# plot.map(t = 0, x = 4, y = 130)
# dev.off()
# 
# d.x <- function(v0, t) t * v0
# d.y <- function(v0, k, t) -16 * t^2 + v0 * t + k
# 
# projectile <- data.frame(T = seq(0, 6, .5))
# projectile$X <- d.x(20, projectile$T)
# projectile$Y <- d.y(100, 0, projectile$T)
# 
# png('./pic/projectile-several-positions.png',
#     width = 900, height = 450)
# plot.map(projectile$T, projectile$X, projectile$Y)
# dev.off()


png('./pic/map-video-%02d.png',
    width = 900, height = 450)
for (i in 1:nrow(projectile)) {
  row <- projectile[i,]
  plot.map(row$T, row$X, row$Y)
}
dev.off()

