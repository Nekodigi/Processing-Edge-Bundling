void point(int i){
  PVector p = points.get(i);
  point(p.x*scale, p.y*scale);
}

void vertex(int i){
  PVector p = points.get(i);
  vertex(p.x*scale, p.y*scale);
}
