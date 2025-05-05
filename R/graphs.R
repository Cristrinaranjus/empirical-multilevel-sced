library(ggplot2)
library(dplyr)
library(patchwork)
library(data.table)  # para rleid()

# Leer los datos
datos <- read.table("dat/ej_medi2.txt", header = TRUE, sep = "\t", dec = ",")

datos <- ej_medi2
colnames(datos) <- c("id_suj", "medi", "session", "fase", "PRED_1")
datos$medi[datos$medi == -99] <- NA

# Aseguramos que 'fase' es factor con etiquetas
datos$fase <- factor(datos$fase,
                     levels = c(0, 1, 2),
                     labels = c("Línea base", "Exposure", "Compassion"))

# Crear identificador de segmentos de línea (bloques donde no cambia fase dentro de sujeto)
datos <- datos %>%
  group_by(id_suj) %>%
  mutate(segmento = data.table::rleid(fase))

# Lista de sujetos
sujetos <- unique(datos$id_suj)
graficos <- list()

# Crear gráficos por sujeto
for (suj in sujetos) {
  df_suj <- datos %>% filter(id_suj == suj)
  max_y <- max(c(df_suj$medi, df_suj$PRED_1), na.rm = TRUE)

  p <- ggplot(df_suj, aes(x = session)) +
    geom_line(aes(y = medi, color = fase, group = segmento), size = 1) +
    geom_line(aes(y = PRED_1), linetype = "dashed") +
    geom_vline(xintercept = 4.5, color = "violet") +
    geom_vline(xintercept = 12.5, color = "violet") +
    annotate("text", x = 2.5, y = max_y + 1, label = "Línea base", size = 3) +
    annotate("text", x = 8.5, y = max_y + 1, label = "Réplica 1", size = 3) +
    annotate("text", x = 16, y = max_y + 1, label = "Réplica 2", size = 3) +
    labs(title = paste("Sujeto:", suj),
         x = "Sesión",
         y = "Puntuación",
         color = "Fase") +
    scale_color_manual(values = c("gray40", "dodgerblue", "firebrick")) +
    theme_minimal()

  graficos[[suj]] <- p
}

# Mostrar todos los gráficos juntos
wrap_plots(graficos, ncol = 2)
