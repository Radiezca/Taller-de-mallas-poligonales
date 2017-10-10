class DR_arista{

  DR_vertice aris_vert1, aris_vert2;
  DR_cara faceA, faceB;
  DR_arista nextA, prevA, nextB, prevB;

  DR_arista(DR_cara faceA_c, DR_vertice aris_vert1_c, DR_vertice aris_vert2_c){    
    faceA= faceA_c;
    aris_vert1 = aris_vert1_c;
    aris_vert2 = aris_vert2_c;
  }
}