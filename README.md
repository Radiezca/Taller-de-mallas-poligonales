---
title:  "Taller de mallas poligonales"
date:   2017-09-01 15:04:23
categories: [Computación Visual]
tags: [Taller]
---
### [Repositorio](https://github.com/Radiezca/Taller-de-mallas-poligonales)

### Descripción código:

* La plantilla inicial constaba de una malla de un QUAD en modo retenido e inmediato. 
* El taller final debe contener 4 forma de visualizar la malla. Normal, nube de puntos, sólo bordes, sólo caras.
* Se implementaron las visualizaciones faltantes para el QUAD.
* Se importó una malla poligonal de un escorpion mecanizado con 87000 vertices en formato .obj.
* Se itera a través de los hijos de la malla y a través de los vertices para crear las formas.
* En modo retenido se utiliza la forma original y una creada a partor de puntos.
* En modo inmeadiato se pintan cada tres vertices por medio de triangulos, cada frame.
* Se necesito cambiar la escala y centrar la malla respecto a sus valores iniciales.
