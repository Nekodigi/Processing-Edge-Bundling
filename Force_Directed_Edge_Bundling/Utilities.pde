//add resampled points to points and, return index
Edge resampledEdge(int start, int end){//designate point with index
  int[] rets = new int[segments+1];
  rets[0] = start;
  rets[segments] = end;
  PVector startP = points.get(start);
  PVector endP = points.get(end);
  int pointsIdx = points.size()-1;
  for(int i=1; i<segments; i++){
    points.add(PVector.lerp(startP, endP, float(i)/segments));
    rets[i] = pointsIdx+i;
  }
  return new Edge(rets);
}

PVector getClosestPoint(PVector a, PVector b, PVector p){
  PVector a2p = PVector.sub(p, a);
  PVector a2b = PVector.sub(b, a);
  float a2b2 = a2b.magSq();
  float t = a2p.dot(a2b)/a2b2;
  return PVector.add(a, a2b.mult(t));
}
