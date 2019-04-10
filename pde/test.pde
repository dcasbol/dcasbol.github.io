float[] past_x;
float[] past_y;

void setup(){
  size(100,100);
  past_x = new float[20];
  past_y = new float[20];
  for(int i=0; i<past_x.length; ++i) past_x[i] = mouseX;
  for(int i=0; i<past_y.length; ++i) past_y[i] = mouseY;
}

void draw(){
  background(0);
  for(int i=1; i<past_x.length; ++i) past_x[i-1] = past_x[i];
  for(int i=1; i<past_y.length; ++i) past_y[i-1] = past_y[i];
  past_x[past_x.length-1] = mouseX;
  past_y[past_y.length-1] = mouseY;
  
  noStroke();
  for(int i=0; i<past_x.length; ++i){
    fill(255, 255*i/(past_x.length*1.0));
    ellipse(past_x[i], past_y[i], 10, 10);
  }
}
