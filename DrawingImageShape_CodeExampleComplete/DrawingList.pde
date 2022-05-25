////////////////////////////////////////////////////////////////////
// DrawingList Class
// this class stores all the drawn shapes during and after thay have been drawn
//
// 
color lineColor;

class DrawingList {

  ArrayList<DrawnShape> shapeList = new ArrayList<DrawnShape>();
  float adjustX;
  float adjustY;
  // this references the currently drawn shape. It is set to null
  // if no shape is currently being drawn
  public DrawnShape currentlyDrawnShape = null;

  public DrawingList() {
  }
  
  public void drawMe() {
    for (DrawnShape s : shapeList) {
      
        s.drawMe();
    }
  }


  public void handleMouseDrawEvent(String shapeType, String mouseEventType, PVector mouseLoc, color shapeColor,color selectedColor) {

    if ( mouseEventType.equals("mousePressed")) {
      if ((mouseX > 20 && mouseX < 247)&& (mouseY > 180 && mouseY < 413)){
          color thisPix = colorSelector.get(mouseX - 20,mouseY -180);
          int r = (int) red(thisPix);
          int g = (int) green(thisPix);
          int b = (int) blue(thisPix);
          selectedColor = color(r,g,b);
          lineColor = color(r,g,b);
          print("Value is ",r,g,b);
      }
      DrawnShape newShape = new DrawnShape(shapeType,shapeColor,selectedColor);
      newShape.startMouseDrawing(mouseLoc);
      shapeList.add(newShape);
      currentlyDrawnShape = newShape;
    }

    if ( mouseEventType.equals("mouseDragged")) {
      if(currentlyDrawnShape != null){
      currentlyDrawnShape.duringMouseDrawing(mouseLoc);
      }
    }

    if ( mouseEventType.equals("mouseReleased")) {
      currentlyDrawnShape.endMouseDrawing(mouseLoc);
    }
    
  }


  

  public void trySelect(String mouseEventType, PVector mouseLoc) {
    if( mouseEventType.equals("mousePressed")){
      
      for (DrawnShape s : shapeList) {
        boolean selectionFound = s.tryToggleSelect(mouseLoc);
       if (selectionFound) break;
      }
    }
  }
  

 
  void deleteSelected(){
    ArrayList<DrawnShape> tempShapeList = new ArrayList<DrawnShape>();
    for (DrawnShape s : shapeList) {
     
        if (s.isSelected == false) tempShapeList.add(s);
      }
    shapeList = tempShapeList;
  }
  

    

}
//for hue
float[] RGBtoHSVh(float r, float g, float b, float h){
  
  
  float minRGB = min( r, g, b );
  float maxRGB = max( r, g, b );
  float adjustHue = h;
  float value = maxRGB/255.0; 
  float delta = maxRGB - minRGB;
  float hue = 0;
  float saturation;
  
  float[] returnVals = {0f,0f,0f};
  

   if( maxRGB != 0 ) {
    // saturation is the difference between the smallest R,G or B value, and the biggest
      saturation = delta / maxRGB; }
   else { // it’s black, so we don’t know the hue
       return returnVals;
       }
       
  if(delta == 0){ 
         hue = 0;
        }
   else {
    // now work out the hue by finding out where it lies on the spectrum
      if( b == maxRGB ) hue = 4 + ( r - g ) / delta;   // between magenta, blue, cyan
      if( g == maxRGB ) hue = 2 + ( b - r ) / delta;   // between cyan, green, yellow
      if( r == maxRGB ) hue = ( g - b ) / delta;       // between yellow, Red, magenta
    }
  // the above produce a hue in the range -6...6, 
  // where 0 is magenta, 1 is red, 2 is yellow, 3 is green, 4 is cyan, 5 is blue and 6 is back to magenta 
  // Multiply the above by 60 to give degrees
   hue = hue * 60;
   if( hue < 0 ) hue += 360;
   
   returnVals[0] = hue * adjustHue;
   returnVals[1] = saturation;
   returnVals[2] = value;
   
   return returnVals;
}

//for saturation
float[] RGBtoHSV(float r, float g, float b){
  
  
  float minRGB = min( r, g, b );
  float maxRGB = max( r, g, b );
  float value = maxRGB/255.0; 
  float delta = maxRGB - minRGB;
  float hue = 0;
  float saturation;
  
  float[] returnVals = {0f,0f,0f};
  

   if( maxRGB != 0 ) {
    // saturation is the difference between the smallest R,G or B value, and the biggest
      saturation = delta / maxRGB; }
   else { // it’s black, so we don’t know the hue
       return returnVals;
       }
       
  if(delta == 0){ 
         hue = 0;
        }
   else {
    // now work out the hue by finding out where it lies on the spectrum
      if( b == maxRGB ) hue = 4 + ( r - g ) / delta;   // between magenta, blue, cyan
      if( g == maxRGB ) hue = 2 + ( b - r ) / delta;   // between cyan, green, yellow
      if( r == maxRGB ) hue = ( g - b ) / delta;       // between yellow, Red, magenta
    }
  // the above produce a hue in the range -6...6, 
  // where 0 is magenta, 1 is red, 2 is yellow, 3 is green, 4 is cyan, 5 is blue and 6 is back to magenta 
  // Multiply the above by 60 to give degrees
   hue = hue * 60;
   if( hue < 0 ) hue += 360;
   
   returnVals[0] = hue;
   returnVals[1] = saturation;
   returnVals[2] = value;
   
   return returnVals;
}





// HSV to RGB
//
//
// expects values in range hue = [0,360], saturation = [0,1], value = [0,1]
color HSVtoRGB(float hue, float sat, float val)
{
  
    hue = hue/360.0;
    int h = (int)(hue * 6);
    float f = hue * 6 - h;
    float p = val * (1 - sat);
    float q = val * (1 - f * sat);
    float t = val * (1 - (1 - f) * sat);

    float r,g,b;


    switch (h) {
      case 0: r = val; g = t; b = p; break;
      case 1: r = q; g = val; b = p; break;
      case 2: r = p; g = val; b = t; break;
      case 3: r = p; g = q; b = val; break;
      case 4: r = t; g = p; b = val; break;
      case 5: r = val; g = p; b = q; break;
      default: r = val; g = t; b = p;
    }
    
    return color(r*255,g*255,b*255);
}
