/*
    Glyphs
    ---------------
    This program procedurally generates glyphs.
    
    Click to generate a random circle of Glyphs
    
    written by Adrian Margel, Winter Early 2020
*/


public class Vector {
  public float x;
  public float y;
  public Vector(float x, float y) {
    this.x=x;
    this.y=y;
  }
  public Vector(float a, float b,boolean angleInit) {
    if(angleInit){
      this.x=cos(a)*b;
      this.y=sin(a)*b;
    }else{
      this.x=a;
      this.y=b;
    }
  }
  public Vector(Vector vec) {
    this.x=vec.x;
    this.y=vec.y;
  }
  public void addVec(Vector vec) {
    x+=vec.x;
    y+=vec.y;
  }
  public void subVec(Vector vec) {
    x-=vec.x;
    y-=vec.y;
  }
  public void sclVec(float scale) {
    x*=scale;
    y*=scale;
  }
  public void nrmVec() {
    sclVec(1/getMag());
  }
  public void nrmVec(float mag) {
    sclVec(mag/getMag());
  }
  public void limVec(float lim) {
    float mag=getMag();
    if (mag>lim) {
      sclVec(lim/mag);
    }
  }
  public float getAng() {
    return atan2(y, x);
  }
  public float getAng(Vector vec) {
    return atan2(vec.y-y, vec.x-x);
  }
  public float getMag() {
    return sqrt(sq(x)+sq(y));
  }
  public float getMag(Vector vec) {
    return sqrt(sq(vec.x-x)+sq(vec.y-y));
  }
  public void rotVec(float rot) {
    float mag=getMag();
    float ang=getAng();
    ang+=rot;
    x=cos(ang)*mag;
    y=sin(ang)*mag;
  }
  public void rotVec(float rot,Vector pin) {
    subVec(pin);
    float mag=getMag();
    float ang=getAng();
    ang+=rot;
    x=cos(ang)*mag;
    y=sin(ang)*mag;
    addVec(pin);
  }
  public void minVec(Vector min){
    x=min(x,min.x);
    y=min(y,min.y);
  }
  public void maxVec(Vector max){
    x=max(x,max.x);
    y=max(y,max.y);
  }
  public boolean inRange(Vector vec,float dist){
    float diffX=abs(vec.x-x);
    if(diffX>dist){
      return false;
    }
    float diffY=abs(vec.y-y);
    if(diffY>dist){
      return false;
    }
    return sqrt(sq(diffX)+sq(diffY))<=dist;
  }
  public void setVec(Vector vec){
    x=vec.x;
    y=vec.y;
  }
}

//generally this will just be a line
class Segment{
  int type;
  float rot;
  Segment(int t,float r){
    type=t;
    rot=r;
  }
  boolean inBounds(Vector start,Vector tar,float xRange,float yRange){
    Vector end=getEnd(start);
    return (abs(end.x-tar.x)<xRange&&abs(end.y-tar.y)<yRange);
  }
  void display(Vector start,Vector pos,float rot,float size){
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(rot);
    Vector end=getEnd(start);
    float microD=100*1/3f;
    
    //display based on the type
    if(type==2){
      float spin=TWO_PI/6;
      float rad=microD;
      Vector pivot=new Vector(rot+PI/2,rad,true);
      pivot.addVec(start);
      arc(pivot.x*size,pivot.y*size,rad*2*size,rad*2*size,rot-PI/2,rot-PI/2+spin);
      end.rotVec(TWO_PI/6,pivot);  
    }else if(type==3){
      float spin=TWO_PI/6;
      float rad=microD;
      Vector pivot=new Vector(rot-PI/2,rad,true);
      pivot.addVec(start);
      arc(pivot.x*size,pivot.y*size,rad*2*size,rad*2*size,rot+PI/2-spin,rot+PI/2);
      end.rotVec(TWO_PI/6,pivot);  
    }else if(type==4){
      float spin=TWO_PI/3;
      float rad=microD;
      Vector pivot=new Vector(rot+PI/2,rad,true);
      pivot.addVec(start);
      arc(pivot.x*size,pivot.y*size,rad*2*size,rad*2*size,rot-PI/2,rot-PI/2+spin);
      end.rotVec(TWO_PI/6,pivot);  
    }else if(type==5){
      float spin=TWO_PI/3;
      float rad=microD;
      Vector pivot=new Vector(rot-PI/2,rad,true);
      pivot.addVec(start);
      arc(pivot.x*size,pivot.y*size,rad*2*size,rad*2*size,rot+PI/2-spin,rot+PI/2);
      end.rotVec(TWO_PI/6,pivot);  
    }else if(type==6){
      float spin=TWO_PI/2;
      float rad=microD;
      Vector pivot=new Vector(rot+PI/2,rad,true);
      pivot.addVec(start);
      arc(pivot.x*size,pivot.y*size,rad*2*size,rad*2*size,rot-PI/2,rot-PI/2+spin);
      end.rotVec(TWO_PI/6,pivot);  
    }else if(type==7){
      float spin=TWO_PI/2;
      float rad=microD;
      Vector pivot=new Vector(rot-PI/2,rad,true);
      pivot.addVec(start);
      arc(pivot.x*size,pivot.y*size,rad*2*size,rad*2*size,rot+PI/2-spin,rot+PI/2);
      end.rotVec(TWO_PI/6,pivot);  
    }else{
      line(start.x*size,start.y*size,end.x*size,end.y*size);
    }
    popMatrix();
    //ellipse(start.x,start.y,10,10);
    //ellipse(getEnd(start).x,getEnd(start).y,10,10);
  }
  
  //get the position where the line will end when displayed
  Vector getEnd(Vector start){
    float bigD=100;
    float shortD=100*2/3f;
    float microD=100*1/3f;
    if(type==0){
      Vector end=new Vector(rot,bigD,true);
      end.addVec(start);
      return end;
    }
    if(type==1){
      Vector end=new Vector(rot,shortD,true);
      end.addVec(start);
      return end;
    }
    if(type==2){
      float spin=TWO_PI/6;
      Vector pivot=new Vector(rot+PI/2,microD,true);
      pivot.addVec(start);
      Vector end=new Vector(start);
      end.rotVec(spin,pivot);
      return end;
    }
    if(type==3){
      float spin=TWO_PI/6;
      Vector pivot=new Vector(rot-PI/2,microD,true);
      pivot.addVec(start);
      Vector end=new Vector(start);
      end.rotVec(-spin,pivot);
      return end;
    }
    if(type==4){
      float spin=TWO_PI/3;
      Vector pivot=new Vector(rot+PI/2,microD,true);
      pivot.addVec(start);
      Vector end=new Vector(start);
      end.rotVec(spin,pivot);
      return end;
    }
    if(type==5){
      float spin=TWO_PI/3;
      Vector pivot=new Vector(rot-PI/2,microD,true);
      pivot.addVec(start);
      Vector end=new Vector(start);
      end.rotVec(-spin,pivot);
      return end;
    }
    if(type==6){
      float spin=TWO_PI/2;
      Vector pivot=new Vector(rot+PI/2,microD,true);
      pivot.addVec(start);
      Vector end=new Vector(start);
      end.rotVec(spin,pivot);
      return end;
    }
    if(type==7){
      float spin=TWO_PI/2;
      Vector pivot=new Vector(rot-PI/2,microD,true);
      pivot.addVec(start);
      Vector end=new Vector(start);
      end.rotVec(-spin,pivot);
      return end;
    }
    if(type==8){
      Vector end=new Vector(rot,microD,true);
      end.addVec(start);
      return end;
    }
    return null;
  }
  
  //if the line will spawn more lines off of it
  boolean isEnd(){
    return type==2||type==3||type==6||type==7;
  }
}

float thickness=1;
float spaceChance=0;

void setup(){
  strokeCap(SQUARE);
  strokeWeight(thickness);
  size(1200,800);
  background(255);
  noFill();
  
  drawRing(new Vector(width/2,height/2),350,0.1);
}
void draw(){
  
}
void drawRing(Vector center,float rad,float size){
  float dist=rad;
  float totalRot=0;
  do{
    Vector drawer=new Vector(totalRot,dist,true);
    drawer.addVec(new Vector(center));
    drawGylph(drawer,totalRot,size);
    //totalRot+=0.1;
    
    float jump=40*size;
    if(random(0,1)<spaceChance){
      jump+=80*size;
      spaceChance=-0.2;
    }
    spaceChance+=0.1;
    
    totalRot+=jump/dist;
  }while(totalRot<TWO_PI);
}
void drawGylph(Vector pos,float rot,float size){
  
  //starting position of the glyph
  Vector start=new Vector(0,0);
  //all points that line segments can spawn from
  ArrayList<Vector> allPoints=new ArrayList<Vector>();
  allPoints.add(new Vector(start));
  
  //how many lines will spawn off the line
  float complexity=3;
  for(int i=0;i<complexity;i++){
    //select a random point to spawn from
    Vector addFrom=allPoints.get((int)random(0,allPoints.size()));
    //create segment
    Segment newSeg=getRandSeg();
    //test if new segment is within a boundry for the letter, if it is in bounds spawn the line
    if(newSeg.inBounds(addFrom,start,60,60)){
      //only add the new end point if the segment is not an ending segment
      if(!newSeg.isEnd()){
        allPoints.add(newSeg.getEnd(addFrom));
      }
      //display the new line
      newSeg.display(addFrom,pos,rot,size);
      drawNode(addFrom,pos,rot,size);
      
    }else{
      //if it failed to spawn then try again
      i--;
    }
  }
}

//get a random segment
Segment getRandSeg(){
  int type=randomType();
  float rot=getRandRot(type);
  return new Segment(type,rot);
}

void drawNode(Vector toDraw,Vector pos,float rot,float size){
  pushMatrix();
  translate(pos.x,pos.y);
  rotate(rot);
  noStroke();
  fill(0);
  ellipse(toDraw.x*size,toDraw.y*size,thickness,thickness);
  stroke(0);
  noFill();
  popMatrix();
}

//select a random segment type
int randomType(){
  //the chances of each type being chosen
  float[] chances=new float[]{1,2,0.5,0.5,0.5,0.5,0.25,0.25,10};
  
  //normalise the chances
  float total=0;
  for(int i=0;i<chances.length;i++){
    total+=chances[i];
  }
  for(int i=0;i<chances.length;i++){
    chances[i]/=total;
  }
  
  //select a random type
  float rand=random(0,1);
  int type=0;
  for(int i=0;i<chances.length;i++){
    rand-=chances[i];
    if(rand<=0){
      type=i;
      break;
    }
  }
  return type;
}

//get a random rotation for a given segment type
float getRandRot(int type){
  ArrayList<Float> opts=new ArrayList<Float>();
  if(type==0){
    for(int i=0;i<6;i++){
      if(i%3==0){
        opts.add(i*TWO_PI/6);
      }
    }
  }else{
    for(int i=0;i<6;i++){
      opts.add(i*TWO_PI/6);
    }
  }
  
  return opts.get((int)random(0,opts.size()))+PI/2;
}

void mousePressed(){
  drawRing(new Vector(mouseX,mouseY),random(100,300),0.1);
}
