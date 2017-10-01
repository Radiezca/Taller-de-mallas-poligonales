class Mesh {
  // radius refers to the mesh 'bounding sphere' redius.
  // see: https://en.wikipedia.org/wiki/Bounding_sphere
  float radius = 200;
  PShape shape;
  PShape shapePunto;
  ArrayList<PVector> vertices;

  // rendering
  boolean retained;

  // visual modes
  // 0. Faces and edges
  // 1. Wireframe (only edges)
  // 2. Only faces
  // 3. Only points
  int mode;

  int tipoComponente = TRIANGLES;
  int cantidadVertices = 0;
  float escala = 0.05;
  PVector vecCentrar = new PVector(0,-100, -30);

  // visual hints
  boolean boundingSphere;

  Mesh() {
    build();
    //use processing style instead of pshape's, see https://processing.org/reference/PShape.html
    shape.disableStyle();
  }

  // compute both mesh vertices and pshape
  // TODO: implement me
  void build() {
    shape = loadShape("scorpion.obj");
    shape.scale(escala);
    shape.translate(vecCentrar.x, vecCentrar.y, vecCentrar.z);
    

    // vertices = new ArrayList<PVector>();    
    // // for example if we were to render a quad:
    // vertices.add(new PVector(-150,150,0));
    // vertices.add(new PVector(150,150,0));
    // vertices.add(new PVector(150,-150,0));
    // vertices.add(new PVector(-150,-150,0));
    // //...

    //Itera a través de los hijos y luego a traves de cada vertice y los asigna al arreglo de vertices
    vertices = new ArrayList<PVector>();
    for (int i = 0; i < shape.getChildCount(); i++) {
      for (int j = 0; j < shape.getChild(i).getVertexCount(); j++) {
      //println("shape.getChild(i).getVertex(j): "+shape.getChild(i).getVertex(j));
      vertices.add(shape.getChild(i).getVertex(j).mult(escala).add(vecCentrar));
      cantidadVertices += 1;
      }
    }

    println("Cantidad de vertices: " + cantidadVertices);

    
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

    //don't forget to compute radius too
  }

  // transfer geometry every frame
  // TODO: current implementation targets a quad.
  // Adapt me, as necessary
  void drawImmediate() {
    if(mode == 3){
      tipoComponente  = POINTS;
    }    

    beginShape(tipoComponente);
    for(PVector v : vertices)
      vertex(v.x, v.y ,v.z);
    endShape();
    tipoComponente  = TRIANGLES;

  }

  void draw() {
    pushStyle();
    
    // mesh visual attributes
    // manipuate me as you wish
    int strokeWeight = 3;
    color lineColor = color(255, retained ? 0 : 255, 0);
    color faceColor = color(0, retained ? 0 : 255, 255, 100);
    
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

    // rendering modes
    if (retained){
      if(mode == 3){
        //println(shapePunto.getVertexCount() + "shapePunto.getVertexCount");
        shape(shapePunto);
      }
      else{
        shape(shape);
      }
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