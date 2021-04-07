class Node{
  private float r;
  private float x;
  private float y;
  private ArrayList<Node> connections;
  
  Node(float x, float y){
    this.r = 0;
    this.x = x;
    this.y = y;
    this.connections = new ArrayList<Node>();
  }
  
  public void connect(Node n){
    this.connections.add(n);
  }
  
  public void draw_node(){
    float r = this.r*255;
    color c = color(r, 255-r, 0);
    fill(c);
    circle(this.x, this.y, NODE_SIZE);
  }
  
  public void draw_connections(){
    Node n;
    for (int i=0; i<this.connections.size(); ++i){
      n = this.connections.get(i);
      line(this.x, this.y, n.x, n.y);
    }
  }
  
  public boolean click(float x, float y){
    return pow(x - this.x, 2) + pow(y - this.y, 2) < pow(NODE_SIZE/2.0, 2);
  }
  
  public float rank(float V){
    float r = this.r;
    for(int i=0; i<this.connections.size(); ++i){
      r += this.connections.get(i).r;
    }
    r *= LAMBDA / this.connections.size();
    r += (1 - LAMBDA) / V;
    return r;
  }
}

class Graph{
  private ArrayList<Node> nodes;
  
  Graph(){
    this.nodes = new ArrayList<Node>();
  }
  
  public int add_node(float x, float y){
    Node node = new Node(x, y);
    this.nodes.add(node);
    return this.nodes.size()-1;
  }
  
  public void connect(int id_a, int id_b){
    this.nodes.get(id_a).connect(this.nodes.get(id_b));
    this.nodes.get(id_b).connect(this.nodes.get(id_a));
  }
  
  public void draw(){
    for(int i=0; i<this.nodes.size(); ++i){
      this.nodes.get(i).draw_connections();
    }
    for(int i=0; i<this.nodes.size(); ++i){
      this.nodes.get(i).draw_node();
    }
  }
  
  public int click(float x, float y){
    for(int i=0; i<this.nodes.size(); ++i){
      if (this.nodes.get(i).click(x, y)){
        return i;
      }
    }
    return -1;
  }
  
  public void rank(){
    float max_rank = 0;
    float V = this.nodes.size();
    float[] ranks = new float[this.nodes.size()];
    for(int i=0; i<this.nodes.size(); ++i){
      ranks[i] = this.nodes.get(i).rank(V);
      max_rank = max(max_rank, ranks[i]);
    }
    max_rank = max(max_rank, 1e-5);
    for(int i=0; i<this.nodes.size(); ++i){
      this.nodes.get(i).r = ranks[i]/max_rank;
    }
  }
}

float LAMBDA = 0.8;

int last_millis = 0;
int sel_node = -1;
Graph G;

int DRAW_MODE = 0;
int RANK_MODE = 1;
int mode = DRAW_MODE;

void setup(){
  size(640, 480);
  background(255);
  frameRate(5);
  G = new Graph();
  last_millis = 0;
}

void draw(){
  if (mode == RANK_MODE){
    if(millis() - last_millis >= 125){
      last_millis = millis();
      G.rank();
    }
  }
  G.draw();
}

void mouseClicked() {
  if (mode != DRAW_MODE) return;
  int c = G.click(mouseX, mouseY);
  if (c < 0){
    G.add_node(mouseX, mouseY);
  }
  else{
    if (sel_node < 0){
      sel_node = c;
    }
    else{
      G.connect(sel_node, c);
      sel_node = -1;
    }
  }
}

void keyPressed(){
  if (mode != DRAW_MODE) return;
  if (keyCode != ENTER) return;
  mode = RANK_MODE;
}

