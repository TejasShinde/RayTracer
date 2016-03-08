///////////////////////////////////////////////////////////////////////
//
//  Ray Tracing Shell
//
///////////////////////////////////////////////////////////////////////

int screen_width = 300;
int screen_height = 300;
int screen_depth = 1;

// global matrix values
PMatrix3D global_mat;
float[] gmat = new float[16];  // global matrix values

// make "timer" a global variable
int timer;

// Some initializations for the scene.

/*Context for list*/
int listSize = -1;

void setup() {
  size (300, 300, P3D);  // Processing 3 does not allow variables as arguments to size() function, hence using values directly
  //size (screen_width, screen_height, P3D);  // use P3D environment so that matrix commands work properly
  noStroke();
  colorMode (RGB, 1.0);
  background (0, 0, 0);
  
  // grab the global matrix values (to use later when drawing pixels)
  PMatrix3D global_mat = (PMatrix3D) getMatrix();
  global_mat.get(gmat);  
  printMatrix();
  //resetMatrix();    // you may want to reset the matrix here

  setNewEnvironment("t01.cli");
}

// Press key 1 to 9 and 0 to run different test cases.

void setNewEnvironment(String filename) {
  pushMatrix();
  resetMatrix();

  /*Create a ray tracer*/
  RayTracer rt = new RayTracer(screen_width, screen_height, screen_depth);

  interpreter(filename, rt);//rect_test.cli");
}

void keyPressed() {
  switch(key) {
    case '1':  setNewEnvironment("t01.cli"); break;
    case '2':  setNewEnvironment("t02.cli"); break;
    case '3':  setNewEnvironment("t03.cli"); break;
    case '4':  setNewEnvironment("t04.cli"); break;
    case '5':  setNewEnvironment("t05.cli"); break;
    case '6':  setNewEnvironment("t06.cli"); break;
    case '7':  setNewEnvironment("t07.cli"); break;
    case '8':  setNewEnvironment("t08.cli"); break;
    case '9':  setNewEnvironment("t09.cli"); break;
    case '0':  setNewEnvironment("t10.cli"); break;
    case 't':  setNewEnvironment("test7.cli"); break;
    case 'q':  exit(); break;
  }
}

//  Parser core. It parses the CLI file and processes it based on each 
//  token. Only "color", "rect", and "write" tokens are implemented. 
//  You should start from here and add more functionalities for your
//  ray tracer.
//
//  Note: Function "splitToken()" is only available in processing 1.25 or higher.

void interpreter(String filename, RayTracer rt) {
  
  String str[] = loadStrings(filename);
  
  /*Create Vertex list for polygons*/
  ArrayList<PVector> VertexList=null;// = new ArrayList<PVector>();
  
  if (str == null) println("Error! Failed to read the file.");
  for (int i=0; i<str.length; i++) {
    
    String[] token = splitTokens(str[i], " "); // Get a line and parse tokens.
    if (token.length == 0) continue; // Skip blank line.
    
    if (token[0].equals("fov")) {
      // TODO
      rt.fov = radians(float(token[1]));
      //rt.fov = rt.fov * (PI / 180); //convert to radians
      println("fov = " + rt.fov);
    }
    else if (token[0].equals("background")) {
      // TODO
      float r = float(token[1]);
      float g = float(token[2]);
      float b = float(token[3]);
      rt.bg = color(r,g,b);
      println("bg = " + rt.bg);
    }
    else if (token[0].equals("point_light")) {
      // TODO
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      float r = float(token[4]);
      float g = float(token[5]);
      float b = float(token[6]);
      rt.AddLightSource(x, y, z, r, g, b);
      if(listSize != -1)  listSize++;
    }
    else if (token[0].equals("diffuse")) {
      // TODO
      float cdr = float(token[1]);
      float cdg = float(token[2]);
      float cdb = float(token[3]);
      rt.current_diffuse_color = color(cdr, cdg, cdb);
      //println("current_diffuse_color = " + rt.current_diffuse_color);
      
      float car = float(token[4]);
      float cag = float(token[5]);
      float cab = float(token[6]);
      rt.current_ambient_color = color(car, cag, cab);
      //println("current_ambient_color = " + rt.current_ambient_color);
    }
    else if (token[0].equals("begin")) {
      // TODO
      //VertexList.clear(); // Remove any previous vertices in the list
      VertexList = new ArrayList<PVector>();
    }
    else if (token[0].equals("end")) {
      // TODO
      rt.AddPolygon(VertexList);
      VertexList = null;
      if(listSize != -1)  listSize++;
    }
    else if (token[0].equals("vertex")) {
      // TODO
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      PVector p = new PVector(x, y, z);
      global_mat = (PMatrix3D) getMatrix();
      global_mat.mult(p,p);
      VertexList.add(new PVector(p.x, p.y, p.z));
    }
    else if (token[0].equals("sphere")) {
      // TODO
      float r = float(token[1]);
      float x = float(token[2]);
      float y = float(token[3]);
      float z = float(token[4]);
      PVector p = new PVector(x, y, z);
      global_mat = (PMatrix3D) getMatrix();
      global_mat.mult(p,p);
      rt.AddSphere(r, p.x, p.y, p.z);
      if(listSize != -1)  listSize++;
    }
    else if (token[0].equals("push")) {
      // TODO
      pushMatrix();
      //resetMatrix();
 //     printMatrix();
 //     println("pushing");
    }
    else if (token[0].equals("pop")) {
      // TODO
      popMatrix();
 //     printMatrix();
 //     println("popping");
    }
    else if (token[0].equals("translate")) {
      // TODO
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      translate(x, y, z);
//      println("Translating by"+" "+x+" "+y+" "+z);
    }
    else if (token[0].equals("rotate")) {
      // TODO
      float angle = float(token[1]);
      float x = float(token[2]);
      float y = float(token[3]);
      float z = float(token[4]);
      //printMatrix();
      rotate(radians(angle), x, y, z);
//      printMatrix();
//      println("Rotating by angle "+angle+" around ["+x+" "+y+" "+z+"]");
    }
    else if (token[0].equals("scale")) {
      // TODO
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      //printMatrix();
      scale(x, y, z);
      //printMatrix();
      println("Scaling by "+x+" "+y+" "+z);
    }
    else if (token[0].equals("read")) {  // reads input from another file
      interpreter (token[1], rt);
    }
    else if (token[0].equals("box")) {
      float xmin = float(token[1]);
      float ymin = float(token[2]);
      float zmin = float(token[3]);
      float xmax = float(token[4]);
      float ymax = float(token[5]);
      float zmax = float(token[6]);
      PVector min = new PVector(xmin, ymin, zmin);
      PVector max = new PVector(xmax, ymax, zmax);
      global_mat = (PMatrix3D) getMatrix();
      global_mat.mult(min, min);
      global_mat.mult(max, max);
      rt.AddBox(min, max);
      if(listSize != -1)  listSize++;
    }
    else if (token[0].equals("begin_list")) {
      listSize = 0;
    }
    else if (token[0].equals("end_list")) {
      rt.AddList(listSize);
      listSize = -1;
    }
    else if (token[0].equals("named_object")) {
      SceneObject obj = rt.getLastSceneObject();
      rt.AddNamedObject(token[1], obj);
      rt.displayObjLists();
    }
    else if (token[0].equals("instance")) {
      SceneObject obj = rt.getNamedObject(token[1]);
      global_mat = (PMatrix3D) getMatrix();
      rt.instantiate(obj, global_mat.get());
      //global_mat.print();
      if(listSize != -1)  listSize++;
    }
    else if (token[0].equals("end_accel")) {
      rt.AddAccel(listSize);
      listSize = -1;
    }
    else if (token[0].equals("reset_timer")) {
      timer = millis();
    }
    else if (token[0].equals("print_timer")) {
      int new_timer = millis();
      int diff = new_timer - timer;
      float seconds = diff / 1000.0;
      println ("timer = " + seconds);
    }
    else if (token[0].equals("rays_per_pixel")) {
      int num = int(token[1]);
      rt.setrpp(num);
    }
    else if (token[0].equals("disk_light")) {
      float x = float(token[1]);  float y = float(token[2]);  float z = float(token[3]);
      float rad = float(token[4]);
      float dx = float(token[5]);  float dy = float(token[6]);  float dz = float(token[7]);
      float r = float(token[8]);  float g = float(token[9]); float b = float(token[10]);
      PVector p = new PVector(x, y, z);
      global_mat = (PMatrix3D) getMatrix();
      global_mat.mult(p,p);
      PVector q = new PVector(dx, dy, dz);
      global_mat = (PMatrix3D) getMatrix();
      global_mat.mult(q,q);
      rt. AddDiskLightSource(p.x, p.y, p.z, rad, q.x, q.y, q.z, r, g, b);
    }
    else if (token[0].equals("moving_sphere")) {
      float radius = float(token[1]);
      float x1 = float(token[2]);  float y1 = float(token[3]);  float z1 = float(token[4]);
      float x2 = float(token[5]);  float y2 = float(token[6]);  float z2 = float(token[7]);
      PVector p = new PVector(x1, y1, z1);
      global_mat = (PMatrix3D) getMatrix();
      global_mat.mult(p,p);
      PVector q = new PVector(x2, y2, z2);
      global_mat = (PMatrix3D) getMatrix();
      global_mat.mult(q,q);
      rt.AddMovingSphere(radius, p.x, p.y, p.z, q.x, q.y, q.z);
    }
    else if (token[0].equals("lens")) {
      float radius = float(token[1]);
      float focal_distance = float(token[2]);
      rt.AddLens(radius, focal_distance);
    }
    else if (token[0].equals("color")) {
      float r = float(token[1]);
      float g = float(token[2]);
      float b = float(token[3]);
      fill(r, g, b);
    }
    else if (token[0].equals("rect")) {
      float x0 = float(token[1]);
      float y0 = float(token[2]);
      float x1 = float(token[3]);
      float y1 = float(token[4]);
      rect(x0, screen_height-y1, x1-x0, y1-y0);
    }
    else if (token[0].equals("write")) {
      // first simulate and raytrace the scene
      popMatrix();   ////////////IMP NOTE: This POP corresponds to PUSH by setNewEnvironment
      //rt.displayObjLists();
      rt.simulate();
      // and then,
      // save the current image to a .png file
      save("./img/"+token[1]);
    }
  }
  println("Sayonara!!!");
}

//  Draw frames.  Should be left empty.
void draw() {
}

// when mouse is pressed, print the cursor location
void mousePressed() {
  //println ("mouse: " + mouseX + " " + mouseY);
}