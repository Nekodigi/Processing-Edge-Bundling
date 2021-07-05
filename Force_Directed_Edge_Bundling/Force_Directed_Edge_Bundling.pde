//based on this paper http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.212.7989&rep=rep1&type=pdf
//refered to this project https://www.youtube.com/watch?v=0teBLrKZ8gU&ab_channel=JunichiroHorikawa

//world
float scale = 10;
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Edge> edges = new ArrayList<Edge>();

//edge bundling
int segments=29;
float K = 0.5;//stiffness
float S = 0.76;//spring strength
float S_rate = 1;//spring strength ratio
float threshold = 0.85899999999999999;//compatibility threshold
//original param edge bundling
float bundlingF = 0.01;
float bundlingSpacing = 0.4;
//visualize
float baseColor;

void setup(){
  size(1000, 1000, P3D);
  //fullScreen(P3D);
  blendMode(ADD);
  colorMode(HSB, 360, 100, 100, 100);
  noFill();
  reset();
}

void keyPressed(){
  if(key=='r'){
    reset();
  }
}

void reset(){
  randomSeed(millis());
  baseColor = 150+random(100);
  points = new ArrayList<PVector>();
  edges = new ArrayList<Edge>();
  
  int N = 400;
  for(int i=0; i<N; i++){
    if(random(1.0)>0.5){//works if even have both direction
    points.add(new PVector(random(-40, 40), 40));//80
    points.add(new PVector(random(-40, 40), -40));
    }else{
    points.add(new PVector(random(-40, 40), 40));
    points.add(new PVector(random(-40, 40), -40));
    }
    
  }
  for(int i=0; i<N; i++){
    Edge e1 = resampledEdge(i*2, i*2+1);
    edges.add(e1); 
  }
  for(Edge edge : edges){
    edge.calcPairs();
  }
}

void draw(){
  background(0);
  //for(int i=0; i<10; i++){
  for(Edge e : edges){
    e.applyForce();
  }
  //}
  
  
  translate(width/2, height/2);
  strokeWeight(2);
  for(int i=0; i<points.size(); i++){
    //point(i);
  }
  randomSeed(0);
  for(Edge edge : edges){
    stroke(baseColor+random(-40, 40), random(0, 100), random(0, 60));
    edge.show();
  }
  S*= S_rate;
}
