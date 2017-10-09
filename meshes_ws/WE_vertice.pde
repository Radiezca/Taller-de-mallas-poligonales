class WE_vertice {  
  ArrayList<WE_arista> aristas_vertice;
  int id;
  PVector coor_vertice;

  WE_vertice(int ver_id, PVector vertice_con){
  	id = ver_id;
  	coor_vertice = vertice_con;

  	aristas_vertice = new ArrayList<WE_arista>();
  }
  //WE_VertexDataObject data;
}