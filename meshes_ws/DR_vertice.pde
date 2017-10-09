class DR_vertice {  
  ArrayList<DR_cara> caras_DR_vertice;
  PVector coor_vertice;

  DR_vertice(PVector vertice_con){
  	coor_vertice = vertice_con;
  	caras_DR_vertice = new ArrayList<DR_cara>();
  }
}