int rowCols = 64;
int spacing = 0;
float zValue = 0.0;

ArrayList<FieldSpace> spaces = new ArrayList<FieldSpace>(rowCols * rowCols);
ArrayList<Point> points = new ArrayList<Point>(100);

void setup()  {
  size(1024, 1024); 
  spacing = width / rowCols;
  
  for(int x = 0; x < rowCols; x++)  {
    for(int y = 0; y < rowCols; y++)  {
      spaces.add(new FieldSpace(float(x), float(y)));  
    }
  }
  for(int i = 0; i < 100; i++)  {
    points.add(new Point());  
  }
  println(points.size());
  noiseDetail(4, 0.5);
  background(10);
  
  //background(255);
  //stroke(25, 5);
  
  //strokeWeight(2);
  colorMode(HSB, 100);
  //smooth();
}

void draw()  {
  //background(20);
  
  for(int i = 0; i < spaces.size(); i++)  {
    //spaces.get(i).show();
    spaces.get(i).update();
  }
  for(int i = 0; i < points.size(); i++)  {
    points.get(i).show();
    points.get(i).update();
  }
  zValue += 0.001;
  
  if(key == 's')  {
    key = 0;
    selectOutput("Choose where to save the image", "saveImage");
  }
}

class FieldSpace {
   PVector pos;
   PVector noisePoint;
   float radians;
   
   void show()  {
     line(this.pos.x, this.pos.y, this.pos.x + cos(this.radians) * 10, this.pos.y + sin(this.radians) * 10); 
   }
   
   void update()  {
     radians = map(noise(this.noisePoint.x, this.noisePoint.y, zValue), 0, 1, 0, TWO_PI);
   }
   
   FieldSpace(float x, float y) {
     pos = new PVector(x * spacing, y * spacing);
     noisePoint = new PVector(x / rowCols, y / rowCols);
   }
}

class Point {
  PVector pos = new PVector(random(width), random(height));
  PVector lastPos = pos.copy();
  PVector acc = new PVector(0, 0);
  int hue;
  
  void show() {
    stroke(map(this.pos.x, 0, width, 0, 100), 100, 100, 5);
    line(this.pos.x, this.pos.y, this.lastPos.x, this.lastPos.y);
  }
  
  void update() {
    float closestDistance = 100000;
    int closestIndex = 0;
    
    for(int i = 0; i < spaces.size(); i++)  {
      float d = pow(spaces.get(i).pos.x - this.pos.x, 2) + pow(spaces.get(i).pos.y - this.pos.y, 2); 
      if(d < closestDistance)  {
        closestIndex = i;  
      }
    }
    
    this.hue = int(map(this.pos.x + this.pos.y, 0, 2048, 0, 100));
    
    this.lastPos = this.pos.copy();
    
    float rads = spaces.get(closestIndex).radians;
    
    this.acc.x += cos(rads);// * 2;
    this.acc.y += sin(rads);// * 2;
    
    this.acc.limit(1);
    
    this.pos.x += this.acc.x;
    this.pos.y += this.acc.y;
    
    if(this.pos.x < 0)  {
      this.pos.x = width; 
      this.lastPos.x = width;
    }  else if(this.pos.x > width)  {
      this.pos.x = 0;  
      this.lastPos.x = 0;
    }
    if(this.pos.y < 0)  {
      this.pos.y = height; 
      this.lastPos.y = height;
    }  else if(this.pos.y > height)  {
      this.pos.y = 0;
      this.lastPos.y = 0;
    }
  }
}

void saveImage(File selection) {
  if (selection != null) {
    save(selection.getAbsolutePath());
  } 
}
