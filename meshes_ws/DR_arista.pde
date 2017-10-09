class DR_arista{

  DR_vertice aris_vert1, aris_vert2;
  DR_cara face;
  DR_arista next;

  DR_arista(DR_cara face_c, DR_vertice aris_vert1_c, DR_vertice aris_vert2_c){    
    face= face_c;
    aris_vert1 = aris_vert1_c;
    aris_vert2 = aris_vert2_c;
  }
}