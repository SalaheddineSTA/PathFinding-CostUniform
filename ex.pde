  
PImage img;
int tour;
int i,j, w, h;
int sk, sl;
float r,g,b;
int [][] temp;
int [][] queue;
int [][] Marque;
int [][] path;
int [][] queue1;
int tete;
int tete1=0;
int drawPath=0;
int tetePath;
int roboti=-1,robotj=-1;
int obji=-1,objj=-1;
boolean weCan=false;
int robotX=0,robotY=0;
int [][]obst={
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1},
        {1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,1},
        {1,0,0,0,1,0,0,1,1,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1},
        {1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1},
        {1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
      }; 


void setup() {
  size(512, 612);
  img = loadImage("im.jpg");
 w=img.width;
 h=img.height;
 tour=0;
 loadPixels();
  img.loadPixels();
  temp=new int[16][16];
  Marque=new int[16][16];
  queue1= new int [1000][4];
  queue= new int [1000][2];
  path= new int [1000][2];
  tetePath=0;
  tete=1;
  for(i=0; i<16; i++)
    for(j=0; j<16; j++)
      {temp[i][j]=obst[i][j]; Marque[i][j]=0;}
      
      //queue[0][0]=1;
      //queue[0][1]=6;
      //queue[0][2]=-1;
      //queue[0][3]=-1; 
}
int ii=0;
void draw() {
    obstacle_creat();
    
for (int x = 0; x < w; x++ ) {
    for (int y = 0; y < h; y++ ) {

      int loc = x + y*w;
      int stepx=w/16;
      int stepy=h/16;
      i= y/stepy; j=x/stepx;
      int val=obst[i][j];
      switch (val)
      {
        case 0: r= 0; g=0; b=0; break;
        case 1: r= 0; g=0; b=255; break;
        case 2: r= 255; g=0; b=0; break;
        case 3: r= 0; g=255; b=0; break;
        case 4: r= 150; g=150; b=150; break;
        case 5: r= 255; g=255; b=255; break;
      }      
      color c = color(r, g, b);
      pixels[loc]=c;      
    }
  }
  
  
  if(obstacle && mousePressed && mouseY<512)
      { print(mouseX/(w/16),mouseY/(h/16),"\n");
          obst[mouseY/(h/16)][mouseX/(w/16)]=1;
          temp[mouseY/(h/16)][mouseX/(w/16)]=1;}

  
  if(robot && mousePressed && mouseY<512 && obst[mouseY/(h/16)][mouseX/(w/16)]!=1 && !start) 
        {if(roboti!=-1 && robotj!=-1)  
            {obst[roboti][robotj]=0;temp[roboti][robotj]=0;}
            roboti=mouseY/(h/16);
            robotj=mouseX/(w/16);
            obst[mouseY/(h/16)][mouseX/(w/16)]=2;
            temp[mouseY/(h/16)][mouseX/(w/16)]=2;
            queue[0][0]=roboti;
            queue[0][1]=robotj;
            Marque[roboti][robotj]=1;
            sk=roboti;sl=robotj;
            robotX=roboti;
            robotY=robotj;
            weCan=true;
     }
     
     
     
     if(objectif && mousePressed && mouseY<512 && obst[mouseY/(h/16)][mouseX/(w/16)]!=1 && !start) {
           if(obji !=-1 && objj!=-1) {obst[obji][objj]=0;temp[obji][objj]=0;}
        obji=mouseY/(h/16);
        objj=mouseX/(w/16);
        print(obji,objj);
        obst[mouseY/(h/16)][mouseX/(w/16)]=3;
        temp[mouseY/(h/16)][mouseX/(w/16)]=3;
     }
    
  
  
  if(tour==0 && start && weCan)  avance();
 
  delay(100);
 
if(tour==-1){tour=2;}
  updatePixels(); 
  
  
  if(tour==2){
       while ((obji!=roboti)||(objj!=robotj))
    {
      
      for (int ii=0; ii<tete1; ii++)
      {
        
        if ((queue1[ii][0]==obji)&&(queue1[ii][1]==objj))
        {
          
          path[tetePath][0]= queue1[ii][2];
          path[tetePath][1]= queue1[ii][3]; 
          obji= path[tetePath][0];
          objj= path[tetePath][1];
          tetePath++;
          break;
        }
      }
    }
    tour=3;   

}
 if(tour==3){  obst[path[drawPath][0]][path[drawPath][1]]=5; drawPath++; if(drawPath==tetePath)tour=4; }
 if(tour==4) { print("END"); }
 
   drawMenu();
   
  
}

int n=0;
boolean bol=false;
boolean found=false;
void avance()
{
  
  int k,l, kk, ll;
  // Trouver les noeuds fils du prelmier element de la file queue
  if(tete==0) {tour=-1;}
  else{
    k=queue[0][0]; 
    l=queue[0][1]; 
    
    obst[k][l]=2; 
    
    obst[sk][sl]=4; 
    sk=k; sl=l; 
    
    
       for(i=0; i<tete-1; i++) 
         {queue[i][0]=queue[i+1][0]; 
         queue[i][1]=queue[i+1][1];} 
         tete--;
       
    
       
    kk=0;ll=-1;
    if(Marque[k+kk][l+ll]==0)
    switch (temp[k+kk][l+ll])
    {
      case 1: break;
      case 0: // enfiler
              queue[tete][0]=k+kk;
              queue[tete][1]=l+ll;
              
              queue1[tete1][0]=k+kk;
              queue1[tete1][1]=l+ll;
              queue1[tete1][2]=k;
              queue1[tete1][3]=l;
              Marque[k+kk][l+ll]=1;
              temp[k+kk][l+ll]=temp[k][l]+1;
              tete++;
              tete1++;//print(tete, "  ");
              break;
      case 3: tour=-1;obji=k+kk;objj=l+ll; 
              queue1[tete1][0]=k+kk;
              queue1[tete1][1]=l+ll;
              queue1[tete1][2]=k;
              queue1[tete1][3]=l;
              tete1++;
             temp[k+kk][l+ll]=temp[k][l]+1; 
                break;
    }
    
    
    kk=0;ll=1;if(Marque[k+kk][l+ll]==0)
    switch (temp[k+kk][l+ll])
    {
      case 1: break;
      case 0: // enfiler
              queue[tete][0]=k+kk;
              queue[tete][1]=l+ll;
              
              queue1[tete1][0]=k+kk;
              queue1[tete1][1]=l+ll;
              queue1[tete1][2]=k;
              queue1[tete1][3]=l;
              Marque[k+kk][l+ll]=1;
              temp[k+kk][l+ll]=temp[k][l]+1;
              tete++;
              tete1++;//print(tete, "  ");
              break;
      case 3: tour=-1;obji=k+kk;objj=l+ll; 
              queue1[tete1][0]=k+kk;
              queue1[tete1][1]=l+ll;
              queue1[tete1][2]=k;
              queue1[tete1][3]=l;
              tete1++;
             temp[k+kk][l+ll]=temp[k][l]+1; 
                break;
    }
    
    
    kk=-1;ll=0;if(Marque[k+kk][l+ll]==0)
    switch (temp[k+kk][l+ll])
    {
      case 1: break;
      case 0: // enfiler
              queue[tete][0]=k+kk;
              queue[tete][1]=l+ll;
              
              queue1[tete1][0]=k+kk;
              queue1[tete1][1]=l+ll;
              queue1[tete1][2]=k;
              queue1[tete1][3]=l;
              Marque[k+kk][l+ll]=1;
              temp[k+kk][l+ll]=temp[k][l]+1;
              tete++;
              tete1++;//print(tete, "  ");
              break;
      case 3: tour=-1;obji=k+kk;objj=l+ll; 
              queue1[tete1][0]=k+kk;
              queue1[tete1][1]=l+ll;
              queue1[tete1][2]=k;
              queue1[tete1][3]=l;
              tete1++;
             temp[k+kk][l+ll]=temp[k][l]+1; 
                break;
    }
    
    
    kk=1;ll=0;if(Marque[k+kk][l+ll]==0)
    switch (temp[k+kk][l+ll])
    {
     case 1: break;
      case 0: // enfiler
              queue[tete][0]=k+kk;
              queue[tete][1]=l+ll;
              
              queue1[tete1][0]=k+kk;
              queue1[tete1][1]=l+ll;
              queue1[tete1][2]=k;
              queue1[tete1][3]=l;
              Marque[k+kk][l+ll]=1;
              temp[k+kk][l+ll]=temp[k][l]+1;
              tete++;
              tete1++;//print(tete, "  ");
              break;
      case 3: tour=-1;obji=k+kk;objj=l+ll; 
              queue1[tete1][0]=k+kk;
              queue1[tete1][1]=l+ll;
              queue1[tete1][2]=k;
              queue1[tete1][3]=l;
              tete1++;
             temp[k+kk][l+ll]=temp[k][l]+1; 
                break;
    }
  }
  
}



void drawMenu(){
        stroke(255);
        fill(128,0,128);
        rect(0,512,128,100);
        textSize(22);
        fill(255);
        text(" Start ",15,568);
        
        stroke(255);
        fill(0,102,153);
        rect(128,512,128,100);
        textSize(22);
        fill(255);
        text(" Obstacle ",143,568);
        
        stroke(255);
        fill(255,0,0);
        rect(256,512,128,100);
        textSize(22);
        fill(255);
        text(" Robot ",271,568);
        
        stroke(255);
        fill(0,255,64);
        rect(384,512,128,100);
        textSize(22);
        fill(255);
        text(" Objectif ",399,568);

}
boolean start,obstacle,robot,objectif;
void obstacle_creat(){
       
       if(mousePressed){
          
          if(mouseX>0 && mouseX<128 && mouseY>512 && mouseY<612){
             start=true; print("s");
             }
          if(mouseX>128 && mouseX<256 && mouseY>512 && mouseY<612){
            robot=false;objectif=false;obstacle = true; print("obs");
             }
          if(mouseX>256 && mouseX<384 && mouseY>512 && mouseY<612){
             obstacle=false;objectif=false; robot = true; print("r");
             }
           if(mouseX>384 && mouseX<512 &&mouseY>512 && mouseY<612){
             objectif = true;obstacle=false; robot=false; print("obj");
             }
           
      
        }
    }