## ------------------------------------------------------
## FUNCIÓN: Imputación de datos con detección de outliers
## CLASE S3: objetoImputacion
## ------------------------------------------------------

imputar_completo_con_outliers <- function(datos) {
  ## 1. Validación de entrada
  stopifnot(is.data.frame(datos))
  
  ## 2. Carga de librerías necesarias
  if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
  pacman::p_load(dplyr, tidyr, purrr, tibble, mice)
  
  ## 3. Identificación de tipos de variables
  vars_numericas    <- names(datos)[sapply(datos, is.numeric)]
  vars_categoricas  <- setdiff(names(datos), vars_numericas)
  
  ## 4. Conversión de categóricas a factor
  datos <- datos %>%
    mutate(across(all_of(vars_categoricas), ~ as.factor(.)))
  
  ## 5. Resumen de NA
  resumen_na <- function(df, vars) {
    df %>%
      summarise(across(all_of(vars), ~ sum(is.na(.)))) %>%
      pivot_longer(cols = everything(), names_to = "variable", values_to = "n_NA") %>%
      mutate(porc_NA = round(n_NA / nrow(df) * 100, 2))
  }
  resumen_na_num <- resumen_na(datos, vars_numericas)
  resumen_na_cat <- resumen_na(datos, vars_categoricas)
  
  ## 6. Imputación preliminar (solo cuantitativas)
  set.seed(123)
  imp1 <- mice(datos[vars_numericas], method = "pmm", m = 1, maxit = 5, print = FALSE)
  datos_cuant_imputados <- complete(imp1)
  
  ## 7. Detección de outliers (por IQR)
  datos_sin_outliers <- datos_cuant_imputados %>%
    mutate(across(everything(), ~ {
      q1 <- quantile(., 0.25, na.rm = TRUE)
      q3 <- quantile(., 0.75, na.rm = TRUE)
      iqr <- q3 - q1
      outlier_idx <- which(. < (q1 - 1.5 * iqr) | . > (q3 + 1.5 * iqr))
      .[outlier_idx] <- NA
      .
    }))
  
  ## 8. Resumen de outliers detectados
  resumen_outliers <- map_dfr(vars_numericas, function(var) {
    tibble(
      variable = var,
      n_outliers = sum(is.na(datos_sin_outliers[[var]]) & !is.na(datos_cuant_imputados[[var]])),
      porc_outliers = round(100 * sum(is.na(datos_sin_outliers[[var]]) & !is.na(datos_cuant_imputados[[var]])) / nrow(datos), 2)
    )
  })
  
  ## 9. Dataset combinado para imputación final
  datos_para_imputar <- bind_cols(datos_sin_outliers, datos[vars_categoricas])
  
  ## 10. Especificación de métodos de imputación
  metodos <- make.method(datos_para_imputar)
  metodos[vars_numericas] <- "pmm"
  metodos[vars_categoricas] <- sapply(datos_para_imputar[vars_categoricas], function(x) {
    if (nlevels(x) == 2) "logreg" else "polyreg"
  })
  
  ## 11. Imputación final
  set.seed(456)
  imp_final <- mice(datos_para_imputar, method = metodos, m = 1, maxit = 5, print = FALSE)
  datos_imputados <- complete(imp_final) %>% as_tibble()
  
  ## 12. Diagnóstico del patrón NA
  patron_na_final <- md.pattern(datos_imputados, plot = FALSE)
  
  ## 13. Eliminación de casos con NA restantes
  datos_limpios <- datos_imputados %>% drop_na()
  
  ## 14. Salida como objeto S3
  resultado <- list(
    datos_imputados = datos_imputados,
    datos_limpios = datos_limpios,
    resumen_na_cuantitativas = resumen_na_num,
    resumen_na_categoricas = resumen_na_cat,
    resumen_outliers = resumen_outliers,
    metodos_usados = metodos,
    patron_na_final = patron_na_final
  )
  class(resultado) <- "objetoImputacion"
  return(resultado)
}


## Método de impresión de salidas :

print.objetoImputacion <- function(x, ...) {
  cat("\n========== IMPUTACIÓN DE DATOS ==========\n")
  
  cat("\n> Resumen NA en variables cuantitativas:\n")
  print(x$resumen_na_cuantitativas)
  
  cat("\n> Resumen NA en variables categóricas:\n")
  print(x$resumen_na_categoricas)
  
  cat("\n> Resumen de outliers tratados como NA:\n")
  print(x$resumen_outliers)
  
  cat("\n> Métodos de imputación utilizados:\n")
  print(as.data.frame(x$metodos_usados))
  
  cat("\n> Patrón de NA posterior a imputación:\n")
  print(x$patron_na_final)
  
  cat("\n> Total de registros completos tras limpieza final: ",
      nrow(x$datos_limpios), "\n")
  
  cat("\n> Acceda a los datos mediante:\n")
  cat("   $datos_imputados\n   $datos_limpios\n")
  invisible(x)
}
