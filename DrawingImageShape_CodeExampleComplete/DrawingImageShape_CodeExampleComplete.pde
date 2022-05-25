// Following on from the example
// DrawSingleShape_CodeExample in week 1 of this unit.
// This example can draw multiple shapes

// Each shape is now contained in a DrawnShape object
// It uses a "DrawingList" to contain all the DrawnShape instances
// as the user creates them
float[][] edge_matrix = { { 0,  -2,  0 },
                          { -2,  8, -2 },
                          { 0,  -2,  0 } }; 
                     
float[][] blur_matrix = {  {0.1,  0.1,  0.1 },
                           {0.1,  0.2,  0.1 },
                           {0.1,  0.1,  0.1 } };                      

float[][] sharpen_matrix = {  { 0, -1, 0 },
                              {-1, 5, -1 },
                              { 0, -1, 0 } };  
                         
float[][] gaussianblur_matrix = { { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.001,  0.020,  0.109, 0.172, 0.109, 0.020, 0.001},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000}
                                  };

SimpleUI myUI;
DrawingList drawingList;
PFont mono;
String toolMode = "";
PImage sourceImage;
PImage outputImage;
PImage colorSelector;
color currentColor;
color fillColor;
color outlineColor;
color selectedColor;
int imageWidth, imageHeight;
color imageColor;
  float adjustX;
  float adjustY;
  float pixelX, pixelY;
void setup() {
  fullScreen(); 
  if(sourceImage != null){
  imageWidth = sourceImage.width;
  imageHeight = sourceImage.height;
  } //<>//
  
  myUI = new SimpleUI();
  drawingList = new DrawingList();
  
  //Sliders
  myUI.addSimpleButton("Reset", width-210, 240);
  Slider sliderBright = myUI.addSlider("Brighten", width- 210, 270);
  sliderBright.setSliderValue(0.5);
  Slider sliderContrast = myUI.addSlider("Contrast",  width- 210, 330);
  sliderContrast.setSliderValue(0.5);
  Slider sliderGBlur = myUI.addSlider("GBlur",  width- 210, 390);
  sliderGBlur.setSliderValue(0.0);
    Slider sliderBlur = myUI.addSlider("Blur",  width- 210, 450);
  sliderBlur.setSliderValue(0.0);
  Slider sliderEdges = myUI.addSlider("Edges",  width- 210, 510);
  sliderEdges.setSliderValue(0.0);
  Slider sliderSharpen = myUI.addSlider("Sharpen",  width- 210, 570);
  sliderSharpen.setSliderValue(0.0);
  Slider sliderHue = myUI.addSlider("Hue",  width- 210, 630);
  sliderHue.setSliderValue(0.0);
  Slider sliderSat = myUI.addSlider("Saturation", width-210, 690);
  sliderSat.setSliderValue(0.0);

  //Buttons
  myUI.addSimpleButton("X", width -50, 0);
  RadioButton  rectButton = myUI.addRadioButton("none", 600,0, "group1");
  myUI.addRadioButton("Rect", 800, 0, "group1");
  myUI.addRadioButton("Ellipse", 1000,0, "group1");
  myUI.addRadioButton("Line", 1200,0, "group1");
  myUI.addRadioButton("Image", 1400,0, "group1");
  myUI.addRadioButton("Select", 380,0, "group1");
  rectButton.selected = true;
  toolMode = rectButton.UILabel;
  
  myUI.addCanvas(width/6 + 40,height/8,width/3 * 2,height/3 * 2 + 200);
  colorSelector = loadImage("colorGrid.png");
  
  myUI.addRadioButton("Set Line", 40, 120, "fill");
  myUI.addSlider("Red Line", 40, 180);
  myUI.addSlider("Green Line", 40, 240);
  myUI.addSlider("Blue Line", 40, 300);
  
  myUI.addRadioButton("Fill Sliders", 40, 460, "colour setting choice").setSelected(true);
  // add sliders
  myUI.addSlider("Red", 40, 500);
  myUI.addSlider("Green", 40, 560);
  myUI.addSlider("Blue", 40, 620);
  
  myUI.addRadioButton("Fill Values", 40, 700, "colour setting choice");
  // add text input boxes
  myUI.addTextInputBox("Red val", 40, 750, "0");
  myUI.addTextInputBox("Green val", 40, 800, "0");
  myUI.addTextInputBox("Blue val", 40, 850, "0");

//Menus
  String[] menuItems = {"Load", "Save", "Exit"}; 
  myUI.addMenu("Menu", 0, 0, menuItems);
  String[] imageFilterItems = {"Original","Grayscale", "Invert", "Red-Green Swap"}; 
  myUI.addMenu("Image Filters", 160, 0, imageFilterItems);
  image(colorSelector, 100, 100, 400, 400);
  
  
}

void draw() {
 background(255);
   
   if(outputImage != null){
      image(outputImage, width/6, height/6);
    }else if(outputImage == null){
      if(sourceImage != null){
        outputImage = sourceImage;
        image(outputImage, height/6, height/6);}
    }

 drawingList.drawMe();
 myUI.update();
 
 float r = 0, g = 0, b = 0;
  
  if ( myUI.getToggleButtonState("Fill Sliders") ) {
    r = myUI.getSliderValue("Red")*255;
    g = myUI.getSliderValue("Green")*255;
    b = myUI.getSliderValue("Blue")*255;
    currentColor=color(r,g,b);
  }
  if ( myUI.getToggleButtonState("Fill Values") ) {
    r = int(myUI.getText("Red val")  );
    g = int(myUI.getText("Green val"));
    b = int(myUI.getText("Blue val"));
    currentColor=color(r,g,b);
  }
  if(myUI.getToggleButtonState("Set Line")){
    r = int(myUI.getText("Red Line")  );
    g = int(myUI.getText("Green Line"));
    b = int(myUI.getText("Blue Line"));
    outlineColor = color(r,g,b);
  }
  
  fill(myUI.getSliderValue("Red Line")*255,myUI.getSliderValue("Green Line")*255,myUI.getSliderValue("Blue Line"));
  rect(240,180,80,180);
  noFill();
  
  
}


void handleUIEvent(UIEventData eventData){
   if(eventData.eventIsFromWidget("Set Line")){
     float r,g,b;
    r = int(myUI.getText("Red Line")  );
    g = int(myUI.getText("Green Line"));
    b = int(myUI.getText("Blue Line"));
    selectedColor = color(r,g,b);
  }
  if(eventData.eventIsFromWidget("Reset")){
    if(sourceImage != null){
      outputImage = sourceImage.copy();
  }}
  if(eventData.eventIsFromWidget("Exit") ||eventData.eventIsFromWidget("X")){
    exit();
  }
  
  if(eventData.eventIsFromWidget("Hue")){
    for (int y = 0; y < sourceImage.height; y++) {
      for (int x = 0; x < sourceImage.width; x++){
        color thisPix = sourceImage.get(x,y);
        int r = (int) (red(thisPix));
        int g = (int) (green(thisPix));
        int b = (int) (blue(thisPix));
        float hueVal = eventData.sliderValue;
        float[] hsv = RGBtoHSVh(r,g,b,hueVal);
        float hue = hsv[0];
        float sat = hsv[1];
        float val = hsv[2];
        
        // do some operation on the hsv values here
        // NOTE: hue is in the range 0...360
        // sat is in the range 0...1
        // val is in the range 0...1
      
        hue += 30;
        if( hue < 0 ) hue += 360;
        if( hue > 360 ) hue -= 360;
        
        color newRGB =   HSVtoRGB(hue,  sat,  val);
        outputImage.set(x,y, newRGB);
      }
    
    }
  }
  if(eventData.eventIsFromWidget("Saturation")){
    for (int y = 0; y < sourceImage.height; y++) {
      for (int x = 0; x < sourceImage.width; x++){
        color thisPix = sourceImage.get(x,y);
        int r = (int) (red(thisPix));
        int g = (int) (green(thisPix));
        int b = (int) (blue(thisPix));
        float satVal = eventData.sliderValue;
        int satInt = round(eventData.sliderValue);
        float[] hsv = RGBtoHSV(r,g,b);
        float hue = hsv[0];
        float sat = hsv[1];
        float val = hsv[2];
        
        // do some operation on the hsv values here
        // NOTE: hue is in the range 0...360
        // sat is in the range 0...1
        // val is in the range 0...1
      
        hue += 30;
        if( hue < 0 ) hue += 360;
        if( hue > 360 ) hue -= 360;
        
        color newRGB =   HSVtoRGB(hue,  satVal,  val);
        saturation(satInt);
        outputImage.set(x,y, newRGB);
        
      }
    
    }
  }

  if(eventData.eventIsFromWidget("Original")){
    if(sourceImage != null){
    outputImage = sourceImage.copy();}
  }
  if(eventData.eventIsFromWidget("Grayscale")){
    if(sourceImage != null){
    outputImage = sourceImage.copy();
    outputImage.filter(GRAY);}
  }
  //Image invert colors event
  if(eventData.eventIsFromWidget("Invert")){
    if(sourceImage != null){
      outputImage = sourceImage.copy();
      outputImage.filter(INVERT);}
  }
  if(eventData.eventIsFromWidget("Red-Green Swap")){
    if(sourceImage != null){
    for (int y = 0; y < sourceImage.height; y++) {
    for (int x = 0; x < sourceImage.width; x++) {

      color thisPix = sourceImage.get(x, y);
      
      float r = red(thisPix);
      float g = green(thisPix);
      float b = blue(thisPix);
      
      // swap takes place here (should be in order r,g,b)
      color swappedColour = color(g, r, b);
      outputImage.set(x, y, swappedColour);

    }
  }
    }
  }
  
  if(eventData.eventIsFromWidget("Brighten")){
    float val = eventData.sliderValue;
    int[] lut =  makeLUT("brighten", 1.5 * val, 0.0);
    if(sourceImage != null){
    outputImage = applyPointProcessing(lut, sourceImage);}
  }
  
  if( eventData.eventIsFromWidget("Brighten")){
    float val = eventData.sliderValue;
    int[] lut =  makeLUT("brighten", 1.5 * val, 0.0);
    if(sourceImage != null){
    outputImage = applyPointProcessing(lut, sourceImage);}
  }
  
  if( eventData.eventIsFromWidget("GBlur")){
    if(sourceImage != null){
      imageWidth = sourceImage.width;
      imageHeight = sourceImage.height;
      outputImage = createImage(sourceImage.width,sourceImage.height,RGB);
      sourceImage.loadPixels();
     
      int matrixSize = 7;
      float blurVal = eventData.sliderValue;
      for(int y = 0; y < imageHeight; y++){
        for(int x = 0; x < imageWidth; x++){
        
        color c = convolution(x, y, gaussianblur_matrix, matrixSize, sourceImage, blurVal);
        
        outputImage.set(x,y,c);
        
        }
      }
    }
  }
  if( eventData.eventIsFromWidget("Edges")){
    if(sourceImage != null){
      imageWidth = sourceImage.width;
      imageHeight = sourceImage.height;
      outputImage = createImage(sourceImage.width,sourceImage.height,RGB);
      sourceImage.loadPixels();
      
      int matrixSize = 3;
      float edgeVal = eventData.sliderValue;
      for(int y = 0; y < imageHeight; y++){
        for(int x = 0; x < imageWidth; x++){
        
        color c = convolution(x, y, edge_matrix, matrixSize, sourceImage, edgeVal);
        
        outputImage.set(x,y,c);
        
        }
      }
    }
  }
  
  if( eventData.eventIsFromWidget("Sharpen")){
    if(sourceImage != null){
      imageWidth = sourceImage.width;
      imageHeight = sourceImage.height;
      outputImage = createImage(sourceImage.width,sourceImage.height,RGB);
      sourceImage.loadPixels();
      
      int matrixSize = 3;
      float sharpVal = eventData.sliderValue;
      for(int y = 0; y < imageHeight; y++){
        for(int x = 0; x < imageWidth; x++){
        
        color c = convolution(x, y, sharpen_matrix, matrixSize, sourceImage, sharpVal);
        
        outputImage.set(x,y,c);
        
        }
      }
    }
  }
  
  if( eventData.eventIsFromWidget("Blur")){
    if(sourceImage != null){
      imageWidth = sourceImage.width;
      imageHeight = sourceImage.height;
      outputImage = createImage(sourceImage.width,sourceImage.height,RGB);
      sourceImage.loadPixels();
      
      int matrixSize = 3;
      float blurVal = eventData.sliderValue;
      for(int y = 0; y < imageHeight; y++){
        for(int x = 0; x < imageWidth; x++){
        
        color c = convolution(x, y, blur_matrix, matrixSize, sourceImage, blurVal);
        
        outputImage.set(x,y,c);
        
        }
      }
    }
  }
 
  if( eventData.eventIsFromWidget("Contrast")){
    if(sourceImage != null){
    float val = eventData.sliderValue;
    int[] lut =  makeLUT("sigmoid", val + 1, 0.0 );
    outputImage = applyPointProcessing(lut, sourceImage);
  }
  }
  
  if( eventData.eventIsFromWidget("negative")){
    if(sourceImage != null){
    int[] lut =  makeLUT("negative", 0.0, 0.0);
    outputImage = applyPointProcessing(lut, sourceImage);}
  }
    // this responds to the "load file" button and opens the file-load dialogue
  if(eventData.eventIsFromWidget("Load")){
    myUI.openFileLoadDialog("load an image");
  }
  
  //this catches the file load information when the file load dialogue's "open" button is hit
  if(eventData.eventIsFromWidget("fileLoadDialog")){
    sourceImage = loadImage(eventData.fileSelection);
     
  }
  

  
  
  //////////////////////////////////////////////////
  // saving a file via the file dialog 
  //
  
  // this responds to the "save file" button and opens the file-save dialogue
  if(eventData.eventIsFromWidget("Save")){
    myUI.openFileSaveDialog("save an image");
  }
  
  //this catches the file save information when the file save dialogue's "save" button is hit
  if(eventData.eventIsFromWidget("fileSaveDialog")){
    PImage canvasImage = get(width/6 + 40,height/8,width/3 * 2 +1,height/3 * 2 + 201);
    canvasImage.save(eventData.fileSelection);
  }
  
  if(eventData.uiComponentType == "RadioButton"){
    toolMode = eventData.uiLabel;
    return;
  }

  // only canvas events below here! First get the mouse point
  if(eventData.eventIsFromWidget("canvas")==false) return;
  PVector p =  new PVector(eventData.mousex, eventData.mousey);
  
  // this next line catches all the tool shape-drawing modes 
  // so that drawing events are sent to the display list class only if the current tool 
  // is a shape drawing tool
  if( toolMode.equals("Rect") || 
      toolMode.equals("Ellipse") || 
      toolMode.equals("Line") ||
      toolMode.equals("Image")){    
     drawingList.handleMouseDrawEvent(toolMode,eventData.mouseEventType,p,currentColor,selectedColor);
  }
  
  // if the current tool is "select" then do this
  if( toolMode.equals("Select") ) {    
      drawingList.trySelect(eventData.mouseEventType, p);
    }
  
 
}

void keyPressed(){

  if(key == BACKSPACE){
    drawingList.deleteSelected();
  }
  
}



int[] makeLUT(String functionName, float param1, float param2){
  int[] lut = new int[256];
  for(int n = 0; n < 256; n++) {
    
    float p = n/255.0f;  // p ranges between 0...1
    float val = getValueFromFunction( p, functionName,  param1,  param2);
    lut[n] = (int)(val*255);
  }
  return lut;
}

float getValueFromFunction(float inputVal, String functionName, float param1, float param2){
  if(functionName.equals("brighten")){
    return simpleScale(inputVal, param1);
  }
  
  if(functionName.equals("step")){
    return step(inputVal, (int)param1);
  }
  
  if(functionName.equals("negative")){
    return invert(inputVal);
  }
  
   if(functionName.equals("sigmoid")){
    return sigmoidCurve(inputVal);
  }
  
  // should only get here is the functionName is undefined
  return 0;
}


PImage applyPointProcessing(int[] LUT,  PImage inputImage){
  PImage outputImage = createImage(inputImage.width,inputImage.height,RGB);
  
  for (int y = 0; y < inputImage.height; y++) {
    for (int x = 0; x < inputImage.width; x++) {
    
    color c = inputImage.get(x,y);
    
    int r = (int)red(c);
    int g = (int)green(c);
    int b = (int)blue(c);
    
    int lutR = LUT[r];
    int lutG = LUT[g];
    int lutB = LUT[b];

    outputImage.set(x,y, color(lutR,lutG,lutB));
    
    }
  }
  
  return outputImage;
}



float getSeconds(){
  float t = millis()/1000.0;
  return t;
}






// makeFunctionLUT
// this function returns a LUT from the range of functions listed
// in the second TAB above
// The parameters are functionName: a string to specify the function used
// parameter1 and parameter2 are optional, some functions do not require
// any parameters, some require one, some two

int[] makeFunctionLUT(String functionName, float parameter1, float parameter2){
  
  int[] lut = new int[256];
  for(int n = 0; n < 256; n++) {
    
    float p = n/256.0f;  // ranges between 0...1
    float val = 0;
    
    switch(functionName) {
      // add in the list of functions here
      // and set the val accordingly
      //
      //
      }// end of switch statement

   
    lut[n] = (int)(val*255);
  }
  
  return lut;
}

color convolution(int Xcen, int Ycen, float[][] matrix, int matrixsize, PImage sourceImage, Float blurVal)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  float blurAmount = blurVal;
  // this is where we sample every pixel around the centre pixel
  // according to the sample-matrix size
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      
      //
      // work out which pixel are we testing
      int xloc = Xcen+i-offset;
      int yloc = Ycen+j-offset;
      
      // Make sure we haven't walked off our image
      if( xloc < 0 || xloc >= sourceImage.width) continue;
      if( yloc < 0 || yloc >= sourceImage.height) continue;
      
      
      // Calculate the convolution
      color col = sourceImage.get(xloc,yloc);
      rtotal += (red(col) * matrix[i][j]) * blurAmount + 1;
      gtotal += (green(col) * matrix[i][j]) * blurAmount + 1;
      btotal += (blue(col) * matrix[i][j]) * blurAmount + 1;
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}
