class Edge{
  int[] pts;//points index of edge
  ArrayList<Integer> pairs = new ArrayList<Integer>();//bundling target index
  
  Edge(int[] pts){
    this.pts = pts;
  }
  
  void calcPairs(){//calc compartibility
    PVector posS = points.get(pts[0]);
    PVector posE = points.get(pts[segments]);//last point
    PVector posM = PVector.add(posS, posE).div(2.0);
    float dist = PVector.dist(posS, posE);
    
    for(int i=0; i<edges.size(); i++){
      Edge target = edges.get(i);
      if(target != this){
        int[] npts = target.pts;
        PVector nposS = points.get(npts[0]);
        PVector nposE = points.get(npts[segments]);
        PVector nposM = PVector.add(nposS, nposE).div(2.0);
        float ndist = PVector.dist(nposS, nposE);
        
        //angle compatibility
        float angle_val = abs(PVector.sub(posE, posS).normalize().dot(PVector.sub(nposE, nposS).normalize()));
        //| ||posE-posS||dot||nposE-nposS|| |
        
        //scale compatibility
        float lavg = (dist + ndist) / 2.0;
        float scale_val = 2.0 / (lavg/min(dist, ndist) + max(dist, ndist)/lavg);
        
        //position compatibility
        float pos_val = lavg / (lavg + PVector.dist(posM, nposM));
        
        //visibility compatibility
        PVector iposS = getClosestPoint(nposS, nposE, posS);
        PVector iposE = getClosestPoint(nposS, nposE, posE);
        PVector iposM = PVector.add(iposS, iposE).div(2.0);
        PVector inposS = getClosestPoint(posS, posE, nposS);
        PVector inposE = getClosestPoint(posS, posE, nposE);
        PVector inposM = PVector.add(inposS, inposE).div(2.0);
        float v1 = max(1.0 - 2*PVector.dist(posM, inposM)/PVector.dist(inposS, inposE),0);
        float v2 = max(1.0 - 2*PVector.dist(nposM, iposM)/PVector.dist(iposS, iposE),0);
        float vis_val = min(v1, v2);
        //println(angle_val, scale_val, pos_val, vis_val);
        
        //combined compatibility
        if(angle_val * scale_val * pos_val * vis_val > threshold){
          pairs.add(i);
        }
      }
    }
  }
  
  void applyForce(){
    PVector posS = points.get(pts[0]);
    PVector posE = points.get(pts[segments]);//last point
    float dist = PVector.dist(posS, posE);
    
    for(int n=1; n<pts.length-1; n++){
      PVector pos = points.get(pts[n]);
      PVector posA = points.get(pts[n-1]);
      PVector posB = points.get(pts[n+1]);
      
      PVector f1 = PVector.sub(posA, pos).mult(K/dist*pts.length);
      PVector f2 = PVector.sub(posB, pos).mult(K/dist*pts.length);
      PVector f3 = new PVector();
      
      for(int i=0; i<pairs.size(); i++){
        int[] npts = edges.get(pairs.get(i)).pts;
        PVector npos = points.get(npts[n]);
        float distNP = PVector.dist(pos, npos);
        PVector tf = PVector.sub(npos, pos).div(distNP/bundlingF);
        if(tf.mag()/bundlingF*bundlingSpacing < distNP){//tf.mag() == 1 and same as 1 < distNP????
          f3.add(tf);//f3+=tf
        }
      }
      PVector f = PVector.add(f1, f2).add(f3).mult(S);
      pos.add(f);//pos+=f
    }
  }
  
  void show(){
    beginShape();
    for(int pi : pts){
      vertex(pi);
    }
    endShape();
  }
}
