class Mesh {
  // radius refers to the mesh 'bounding sphere' redius.
  // see: https://en.wikipedia.org/wiki/Bounding_sphere
  float radius = 200;

  //shape para cargar obj
  PShape shape;
  PShape shapePunto;
  ArrayList<PVector> vertices;

  //shape para dibujo
  PShape shape_dibujar;
  
  //Winged Edge.
  PShape shapeWE;
  PShape shapeWE_punto;
  ArrayList<PVector> vert_WE;
  ArrayList<WE_arista> list_WE_aris;
  ArrayList<WE_cara> list_WE_cara;
  ArrayList<WE_vertice> list_WE_vert;

  //Face vertex.
  PShape shapeFV;
  PShape shapeFV_punto;
  ArrayList<PVector> vert_FV;
  ArrayList<FV_cara> list_FV_cara;
  ArrayList<FV_vertice> list_FV_vert;

  //Dynamic render.
  PShape shapeDR;
  PShape shapeDR_punto;
  ArrayList<PVector> vert_DR;
  ArrayList<DR_arista> list_DR_aris;
  ArrayList<DR_cara> list_DR_cara;
  ArrayList<DR_vertice> list_DR_vert;  


  // rendering
  boolean retained = true;

  // visual modes
  // 0. Faces and edges
  // 1. Wireframe (only edges)
  // 2. Only faces
  // 3. Only points
  int mode;

  //Reperensetacion 
  // 0. Processing por defecto FV. Face vertex directo desde el obj.
  // 1. FV. Face vertex usando listas.
  // 2. WE. Winged edge.
  // 3. RD. Dinamyc rendering.
  // 4. Vertex vertex.
  int representacion;

  // Cambiar el tipo de primitiva usada para las formas. Escalar y centrar el obj improtado.
  int tipoComponente = TRIANGLES;
  float escala = 0.05;
  PVector vecCentrar = new PVector(0,-100, -30);

  // visual hints
  boolean boundingSphere;

  Mesh() {
    build();
    //use processing style instead of pshape's, see https://processing.org/reference/PShape.html
    shape.disableStyle();
    shapePunto.disableStyle();

    shapeWE.disableStyle();
    shapeWE_punto.disableStyle();

    shapeFV.disableStyle();
    shapeFV_punto.disableStyle();

    shapeDR.disableStyle();
    shapeDR_punto.disableStyle();
    
  }

  // compute both mesh vertices and pshape
  // TODO: implement me
  void build() {
    shape = loadShape("scorpion.obj");
    shape.scale(escala);
    shape.translate(vecCentrar.x, vecCentrar.y, vecCentrar.z);

    //WE
    crea_lista_vertices_dibujar_desde_winged_edge();    
    shapeWE = createShape();
    shapeWE.beginShape(TRIANGLES);
    for(PVector v : vert_WE){
      shapeWE.vertex(v.x, v.y ,v.z);
    }
    shapeWE.endShape();

    shapeWE_punto = createShape();
    shapeWE_punto.beginShape(POINTS);
    shapeWE_punto.strokeWeight(3);
    shapeWE_punto.stroke(255, 0, 0);
    for(PVector v : vert_WE)
      shapeWE_punto.vertex(v.x, v.y ,v.z);
    shapeWE_punto.endShape();


    //FV
    crea_lista_vertices_dibujar_desde_face_vertex();    
    shapeFV = createShape();
    shapeFV.beginShape(TRIANGLES);
    for(PVector v : vert_WE){
      shapeFV.vertex(v.x, v.y ,v.z);
    }
    shapeFV.endShape();

    shapeFV_punto = createShape();
    shapeFV_punto.beginShape(POINTS);
    shapeFV_punto.strokeWeight(3);
    shapeFV_punto.stroke(255, 0, 0);
    for(PVector v : vert_WE)
      shapeFV_punto.vertex(v.x, v.y ,v.z);
    shapeFV_punto.endShape();

    //DR
    crea_lista_vertices_dibujar_desde_dynamic_render();    
    shapeDR = createShape();
    shapeDR.beginShape(TRIANGLES);
    for(PVector v : vert_DR){
      shapeDR.vertex(v.x, v.y ,v.z);
    }
    shapeDR.endShape();

    shapeDR_punto = createShape();
    shapeDR_punto.beginShape(POINTS);
    shapeDR_punto.strokeWeight(3);
    shapeDR_punto.stroke(255, 0, 0);
    for(PVector v : vert_DR)
      shapeDR_punto.vertex(v.x, v.y ,v.z);
    shapeDR_punto.endShape();

        

    // vertices = new ArrayList<PVector>();    
    // // for example if we were to render a quad:
    // vertices.add(new PVector(-150,150,0));
    // vertices.add(new PVector(150,150,0));
    // vertices.add(new PVector(150,-150,0));
    // vertices.add(new PVector(-150,-150,0));
    
    
    //Processing FV
    //Itera a través de los hijos y luego a traves de cada vertice y los asigna al arreglo de vertices
    vertices = new ArrayList<PVector>();
    for (int i = 0; i < shape.getChildCount(); i++) {
      for (int j = 0; j < shape.getChild(i).getVertexCount(); j++) {
      //println("shape.getChild(i).getVertex(j): "+shape.getChild(i).getVertex(j));
      vertices.add(shape.getChild(i).getVertex(j).mult(escala).add(vecCentrar));
      }
    }

    println("Cantidad de vertices: " + vertices.size());

    
    // shape = createShape();
    // shape.beginShape(QUADS);
    // for(PVector v : vertices)
    //   shape.vertex(v.x, v.y ,v.z);
    // shape.endShape();

    shapePunto = createShape();
    shapePunto.beginShape(POINTS);
    shapePunto.strokeWeight(3);
    shapePunto.stroke(255, 0, 0);
    for(PVector v : vertices)
      shapePunto.vertex(v.x, v.y ,v.z);
    shapePunto.endShape();


    //Por defecto shape para dibujar tiene la forma cargada.
    shape_dibujar = shape;
  }

  void crea_lista_vertices_dibujar_desde_winged_edge(){

    crea_listas_WE();
    for(WE_cara cara_actual : list_WE_cara){
      for(WE_arista aris_actual : cara_actual.aristasCara){
        vert_WE.add(aris_actual.aris_vert1.coor_vertice);
      }
    }
    //println("vert_WE: "+vert_WE);
  }

  // La representacion WE usa 3 listas. E-V-F-E, F-E y V-E.
  void crea_listas_WE(){
    vert_WE = new ArrayList<PVector>();
    list_WE_aris = new ArrayList<WE_arista>();
    list_WE_cara = new ArrayList<WE_cara>();
    list_WE_vert = new ArrayList<WE_vertice>() ;
    int vert_trian = 3;
    int num_vert;

    for (int i = 0; i < shape.getChildCount(); i ++) {
      //sumarde 3 en 3 y agregar las 3 aristas de una ves.
      // ir creando al lista de caras de una vez. A cada arista extraerle la cara y agregarla a la lista de caras.
      // utilizar los ID de las aristas y de la lista de aristas extraer los vertices, eligiendo el primer vertice de
      // cada arista para solo obtener 3 necesarios para construir el triangulo      
      for (int j = 0; j < shape.getChild(i).getVertexCount(); j +=3) {
        num_vert = vert_trian * i;

        //Crear las dos de las listas correspondientes a la representacion WE. F-E, V-E.                
        //Se lige el primer vertice de cada arista.
        
        //list_WE_vert.add(new WE_vertice(j, shape.getChild(i).getVertex(j).mult(escala).add(vecCentrar) )  ) );
        
        list_WE_vert.add(new WE_vertice(num_vert, shape.getChild(i).getVertex(j).mult(escala).add(vecCentrar) )  ) ;
        list_WE_vert.add(new WE_vertice(num_vert+ 1, shape.getChild(i).getVertex(j+1).mult(escala).add(vecCentrar) ) );
        list_WE_vert.add(new WE_vertice(num_vert+ 2, shape.getChild(i).getVertex(j+2).mult(escala).add(vecCentrar) ) );
        list_WE_cara.add(new WE_cara (i));

        //Crear la lista grande de la representacion WE. La E-V-F-E.
        list_WE_aris.add( new WE_arista(num_vert, list_WE_cara.get(i), list_WE_vert.get(num_vert), list_WE_vert.get(num_vert +1) ) );
        list_WE_aris.add( new WE_arista(num_vert +1, list_WE_cara.get(i), list_WE_vert.get(num_vert +1), list_WE_vert.get(num_vert +2) ) );
        list_WE_aris.add( new WE_arista(num_vert +2, list_WE_cara.get(i), list_WE_vert.get(num_vert +2), list_WE_vert.get(num_vert) ) );

        //Agregar las aristas que le pertenecen a cada cara 
        list_WE_cara.get(i).aristasCara.add(list_WE_aris.get(num_vert ) );
        list_WE_cara.get(i).aristasCara.add(list_WE_aris.get(num_vert +1 ) );
        list_WE_cara.get(i).aristasCara.add(list_WE_aris.get(num_vert +2 ) );

        //Agrega las aristas asociadas a cada vertice
        //vertices 1 y 2 asociado a aristas 1
        list_WE_vert.get(num_vert).aristas_vertice.add(list_WE_aris.get(num_vert) );
        list_WE_vert.get(num_vert+1).aristas_vertice.add(list_WE_aris.get(num_vert) );
        //vertices 2 y 3 asociado a aristas 2
        list_WE_vert.get(num_vert+1).aristas_vertice.add(list_WE_aris.get(num_vert+1) );
        list_WE_vert.get(num_vert+2).aristas_vertice.add(list_WE_aris.get(num_vert+1) );
        //vertices 3 y 1 asociado a aristas 3
        list_WE_vert.get(num_vert+1).aristas_vertice.add(list_WE_aris.get(num_vert+2) );
        list_WE_vert.get(num_vert).aristas_vertice.add(list_WE_aris.get(num_vert+2) );

        /*//Agregar las aristas que le pertenecen a cada cara de cada arista.
        list_WE_aris.get(j).face.aristasCara.add(list_WE_aris.get(j));
        list_WE_aris.get(j).face.aristasCara.add(list_WE_aris.get(j+1));
        list_WE_aris.get(j).face.aristasCara.add(list_WE_aris.get(j+2));

        list_WE_aris.get(j).arist_vert1;
        list_WE_aris.get(j+1).arist_vert1;
        list_WE_aris.get(j+2).arist_vert1;*/

        /*//Crear las otras dos listas correspondientes a la representacion WE. Ya esta E-V-F-E, ahora F-E, V-E.        
        list_WE_cara.add(list_WE_aris.get(j).face);
        //Se lige el primer vertice de cada arista.
        list_WE_vert.add(list_WE_aris.get(j).arist_vert1))
        list_WE_vert.add(list_WE_aris.get(j+1).arist_vert1))
        list_WE_vert.add(list_WE_aris.get(j+2).arist_vert1))*/
      }
    }
    // int k  = 0 ;
    // for(WE_vertice vert_actual : list_WE_vert){
    //   println("vert_actual.coor_vertice(k)" + k + " :"+vert_actual.coor_vertice);
    //   k++;
    // }
  }

  void crea_lista_vertices_dibujar_desde_face_vertex(){

    crea_listas_FV();
    for(FV_cara cara_actual_FV : list_FV_cara){
      for(FV_vertice vertice_actual_FV : cara_actual_FV.vertices_FV_cara){
        vert_FV.add(vertice_actual_FV.coord_vect);
      }
    }
  }

  //La representacion Face vertes utiliza dos listas. F-V y V-F.
  void crea_listas_FV(){

    int cantidad_vert_cara;
    int num_vert;

    vert_FV = new ArrayList<PVector>();    
    list_FV_cara = new ArrayList<FV_cara>();
    list_FV_vert = new ArrayList<FV_vertice>();

    vertices = new ArrayList<PVector>();
    for (int i = 0; i < shape.getChildCount(); i++) {
      for (int j = 0; j < shape.getChild(i).getVertexCount(); j +=3) {
        cantidad_vert_cara = shape.getChild(i).getVertexCount();
        num_vert = cantidad_vert_cara * i;

        list_FV_vert.add(new FV_vertice ( shape.getChild(i).getVertex(j).mult(escala).add(vecCentrar) ) );
        list_FV_vert.add(new FV_vertice ( shape.getChild(i).getVertex(j+1).mult(escala).add(vecCentrar) ) );
        list_FV_vert.add(new FV_vertice ( shape.getChild(i).getVertex(j+2).mult(escala).add(vecCentrar) ) );
        list_FV_cara.add( new FV_cara ( list_FV_vert.get(num_vert), list_FV_vert.get(num_vert+1), list_FV_vert.get(num_vert+2)  ) );
        list_FV_vert.get(num_vert).caras_FV_vertice.add(list_FV_cara.get(i));
        list_FV_vert.get(num_vert+1).caras_FV_vertice.add(list_FV_cara.get(i));
        list_FV_vert.get(num_vert+2).caras_FV_vertice.add(list_FV_cara.get(i));
      }
    }

  }

  void crea_lista_vertices_dibujar_desde_dynamic_render(){

    crea_listas_DR();
    for(DR_cara cara_actual_DR : list_DR_cara){
      for(DR_vertice vertice_actual_DR : cara_actual_DR.vertices_DR_cara){
        vert_DR.add(vertice_actual_DR.coor_vertice);
      }
    }
  }

  // La representacion DR usa 3 listas. F-V, E-V-F-E y V-F. 
  void crea_listas_DR(){
    vert_DR = new ArrayList<PVector>();
    list_DR_aris = new ArrayList<DR_arista>();
    list_DR_cara = new ArrayList<DR_cara>();
    list_DR_vert = new ArrayList<DR_vertice>() ;
    int cantidad_vert_cara;
    int num_vert;

    for (int i = 0; i < shape.getChildCount(); i ++) {
      //sumarde 3 en 3 y agregar las 3 aristas de una ves.
      // ir creando al lista de caras de una vez. A cada arista extraerle la cara y agregarla a la lista de caras.
      // utilizar los ID de las aristas y de la lista de aristas extraer los vertices, eligiendo el primer vertice de
      // cada arista para solo obtener 3 necesarios para construir el triangulo      
      for (int j = 0; j < shape.getChild(i).getVertexCount(); j +=3) {
        cantidad_vert_cara = shape.getChild(i).getVertexCount();
        num_vert = cantidad_vert_cara * i;

        list_DR_vert.add(new DR_vertice ( shape.getChild(i).getVertex(j).mult(escala).add(vecCentrar) ) );
        list_DR_vert.add(new DR_vertice ( shape.getChild(i).getVertex(j+1).mult(escala).add(vecCentrar) ) );
        list_DR_vert.add(new DR_vertice ( shape.getChild(i).getVertex(j+2).mult(escala).add(vecCentrar) ) );
        list_DR_cara.add(new DR_cara ( list_DR_vert.get(num_vert), list_DR_vert.get(num_vert+1), list_DR_vert.get(num_vert+2)  ) );
        list_DR_vert.get(num_vert).caras_DR_vertice.add(list_DR_cara.get(i));
        list_DR_vert.get(num_vert+1).caras_DR_vertice.add(list_DR_cara.get(i));
        list_DR_vert.get(num_vert+2).caras_DR_vertice.add(list_DR_cara.get(i));
        list_DR_aris.add( new DR_arista( list_DR_cara.get(i), list_DR_vert.get(num_vert), list_DR_vert.get(num_vert +1) ) );
        list_DR_aris.add( new DR_arista( list_DR_cara.get(i), list_DR_vert.get(num_vert +1), list_DR_vert.get(num_vert +2) ) );
        list_DR_aris.add( new DR_arista( list_DR_cara.get(i), list_DR_vert.get(num_vert +2), list_DR_vert.get(num_vert) ) );
      }
    }
  }


  // transfer geometry every frame
  // TODO: current implementation targets a quad.
  // Adapt me, as necessary
  void drawImmediate() {

    if(mode == 3){
        tipoComponente  = POINTS;
    }
    else{
        tipoComponente  = TRIANGLES;
    }

    switch(representacion) {
    case 0:
      println("Processing FV");
      beginShape(tipoComponente);
      for(PVector v : vertices)
        vertex(v.x, v.y ,v.z);
      endShape();
      break;

    case 1:
      println("FV");
      beginShape(tipoComponente);
      for(FV_cara cara_actual_FV : list_FV_cara){
        for(FV_vertice vertice_actual_FV : cara_actual_FV.vertices_FV_cara){
          //vertex(vertice_actual_FV.coord_vect.array());
          vertex(vertice_actual_FV.coord_vect.x, vertice_actual_FV.coord_vect.y, vertice_actual_FV.coord_vect.z);
        }
      }
      endShape();
      break;

    case 2:
      println("WE");
      beginShape(tipoComponente);
      for(WE_cara cara_actual : list_WE_cara){
        for(WE_arista aris_actual : cara_actual.aristasCara){
          vertex( aris_actual.aris_vert1.coor_vertice.x, aris_actual.aris_vert1.coor_vertice.y, aris_actual.aris_vert1.coor_vertice.z ) ;
        }
      }
      endShape();
      break;

    case 3:

      println("Dynamic");
      beginShape(tipoComponente);
      for(DR_cara cara_actual_DR : list_DR_cara){
        for(DR_vertice vertice_actual_DR : cara_actual_DR.vertices_DR_cara){
          vertex(vertice_actual_DR.coor_vertice.x, vertice_actual_DR.coor_vertice.y, vertice_actual_DR.coor_vertice.z);
        }
      }
      endShape();
        
      break;


    case 4:
      
      break;

    }
  }

  void draw() {
    pushStyle();
    
    // mesh visual attributes
    // manipuate me as you wish
    int strokeWeight = 3;
    color lineColor = color(255, retained ? 0 : 255, 0);
    color faceColor = color(0, retained ? 0 : 255, 255);
    
    strokeWeight(strokeWeight);
    stroke(lineColor);
    fill(faceColor);    
    // visual modes
    switch(mode) {
    case 0:
      fill(faceColor);
      stroke(lineColor);
      break;
    case 1:
      noFill();
      break;
    case 2:
      noStroke();
      break;
    case 3:
      //Implementado en los modos de render.
      break;
    }

    //Representaciones
    switch(representacion) {
    case 0:
      println("Processing FV");

      if (mode == 3) {
        shape_dibujar = shapePunto;        
      }
      else{
        shape_dibujar = shape;
      }

      break;


    case 1:
      println("FV");

      if (mode == 3) {
        shape_dibujar = shapeFV_punto;        
      }
      else{
        shape_dibujar = shapeFV;
      }

      break;


    case 2:
      println("WE");
      if (mode == 3) {
        shape_dibujar = shapeWE_punto;        
      }
      else{
        shape_dibujar = shapeWE;
      }
      break;

    case 3:
      println("Dynamic");

      if (mode == 3) {
        shape_dibujar = shapeDR_punto;
      }
      else{
        shape_dibujar = shapeDR;
      }
      
      break;
    case 4:
      
      break;
    }    

    // rendering modes
    if (retained){
        shape(shape_dibujar);      
    }
    else{
      drawImmediate();
    }

    popStyle();

    // visual hint
    if (boundingSphere) {
      pushStyle();
      noStroke();
      fill(0, 255, 255, 125);
      sphere(radius);
      popStyle();
    }
  }
}