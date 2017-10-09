class WE_arista {

  WE_vertice aris_vert1, aris_vert2;
  WE_cara face;
  WE_arista next;
  int id;
  //WE_EdgeDataObject data;

/*  WE_arista(int aris_id, int cara_id, int id_vertA, int id_vertB, Pvector vertA, Pvector vertB){
    id = aris_id;
    face.id = cara_id;

    WE_vertice we_vert1 = new WE_vertice(id_vertA, vertA);
    WE_vertice we_vert2 = new WE_vertice(id_vertB, vertB);
    aris_vert1 = we_vert1;
    aris_vert2 = we_vert2;

  }*/
  WE_arista(int aris_id_c, WE_cara face_c, WE_vertice aris_vert1_c, WE_vertice aris_vert2_c){
    id = aris_id_c;
    face= face_c;
    aris_vert1 = aris_vert1_c;
    aris_vert2 = aris_vert2_c;
  }
}