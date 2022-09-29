<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.oreilly.servlet.*"%> <!-- cos.jar에서 제공 -->
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%@ page import="javax.imageio.*" %>
<%@ page import="java.awt.image.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Color Image Processing - Server (RC 1)</title>
</head>
<body>
<%! 
////////////////
// 전역변수부
////////////////
int[][][] inImage;
int inH,inW;
int[][][] outImage;
int outH,outW;
File inFp,outFp;
double tmpInImage[][][];
double tmpOutImage[][][];
double[][][] mask;
double[] rgb = new double[3];
double[] hsv = new double[3];
double[] abc = new double[3];
double[] def = new double[3];
//Parameter Variable
String algo, para1, para2;
String inFname,outFname;

////////////////
// 공통 함수부
////////////////

////////////////
// 영상처리 함수부
////////////////
public void reverseImage(){
	//반전영상
	//(중요!) 출력영상의 크기를 결정(알그리즘에 의존)
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	//**Image Processing Algorithm**
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				outImage[rgb][i][k]=255-inImage[rgb][i][k];
			}
		}
	}
}
public void addImage(){
	//Add Image 영상
	//(중요!) 출력영상의 크기를 결정(알그리즘에 의존)
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	//**Image Processing Algorithm**
	int value=Integer.parseInt(para1);
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				if(inImage[rgb][i][k]+value>255)
					outImage[rgb][i][k]=255;
				else if(inImage[rgb][i][k]+value<0)
					outImage[rgb][i][k]=0;
				else{
					outImage[rgb][i][k]=inImage[rgb][i][k]+value;
				}
			}
		}
	}
}
public void grayScaleImage(){
	//Add Image 영상
	//(중요!) 출력영상의 크기를 결정(알그리즘에 의존)
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	//**Image Processing Algorithm**
	int value=Integer.parseInt(para1);
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			int sumvalue=inImage[0][i][k]+inImage[1][i][k]+inImage[2][i][k];
			int avgvalue=(int) sumvalue/3;
			outImage[0][i][k]=avgvalue;
			outImage[1][i][k]=avgvalue;
			outImage[2][i][k]=avgvalue;
		}
	}
}
public void blackwhiteImage(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			int sumvalue=inImage[0][i][k]+inImage[1][i][k]+inImage[2][i][k];
			int avgvalue=(int) sumvalue/3;
			if(avgvalue>127){
				outImage[0][i][k]=255;
				outImage[1][i][k]=255;
				outImage[2][i][k]=255;
			}else{
				outImage[0][i][k]=0;
				outImage[1][i][k]=0;
				outImage[2][i][k]=0;
			}
		}
	}
}
public void equalImage(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			outImage[rgb][i][k]=inImage[rgb][i][k];
		}
	}
	}
}
public void gammaImage(){
	//감마
	outH =inH;
	outW =inW;
	// 메모리 할당
	outImage = new int[3][outH][outW];
	/// ** Image Processing Algorithm **
	double value = Double.parseDouble(para1);
	if(value <0)
		value =1/(1-value);
	else
		value +=1;

	//감마 변환
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0; i<inH; i++){
		for(int k=0; k<inW; k++){
			double result=(Math.pow((double)(inImage[rgb][i][k]/255.0),(double)(value))*255+0.5);
			if(result <0)
				result=0;
			else if(result >255)
				result=255;
			outImage[rgb][i][k] = (int)result;
		}
	}
	}
}
public void paraCap(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			outImage[rgb][i][k]=255-(int)Math.pow((inImage[rgb][i][k]/127-1),2)*255;
		}
	}
	}
}
public void paraCup(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				outImage[rgb][i][k]=(int)Math.pow((inImage[rgb][i][k]/127-1),2)*255;
			}
		}
	}
}
public void leftrightImage(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				outImage[rgb][i][k]=inImage[rgb][inH-1-i][k];
			}
		}
	}
}
public void updownImage(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			outImage[rgb][i][k]=inImage[rgb][i][inW-1-k];
		}
	}
	}
}
public void zoonInImage(){ 
	int scale=Integer.parseInt(para1);
	outH=inH*scale;
	outW=inW*scale;
	outImage=new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<outH;i++){
		for(int k=0;k<outW;k++){
			outImage[rgb][i][k]=inImage[rgb][i/scale][k/scale];
		}
	}
	}
}
public void zoonInImage1(){ //전방향
	int scale=Integer.parseInt(para1);
	outH=(int)(inH*scale);
	outW=(int)(inW*scale);
	outImage=new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			outImage[rgb][(int)(i*scale)][(int)(k*scale)]=inImage[rgb][i][k];
		}
	}
	}
}
public void zoomOutImage(){ 
	int scale=Integer.parseInt(para1);
	outH=inH/scale;
	outW=inW/scale;
	outImage=new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			outImage[rgb][(int)i/scale][(int)k/scale]=inImage[rgb][i][k];
		}
	}
	}
}
public void moveImage() {
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	int x = Integer.parseInt(para2);
	int y = Integer.parseInt(para1);

	for(int rgb=0; rgb<3; rgb++){
		for(int i=0; i<inH-y; i++) {
			for(int k=0; k<inW-x; k++) {
				outImage[rgb][i+y][k+x] = inImage[rgb][i][k];
			}
		}
	}
}
public void rotateImage(){
	int CenterH, CenterW, newH, newW , Val;
	double Radian, PI;
	// PI = 3.14159265358979;
	PI = Math.PI;
	int degree = Integer.parseInt(para1);
	Radian = -degree * PI / 180.0; 
	outH = (int)(Math.floor((inW) * Math.abs(Math.sin(Radian)) + (inH) * Math.abs(Math.cos(Radian))));
	outW = (int)(Math.floor((inW) * Math.abs(Math.cos(Radian)) + (inH) * Math.abs(Math.sin(Radian))));
	CenterH = outH / 2;
	CenterW = outW / 2;
	outImage = new int[3][outH][outW];
	
	for (int rgb = 0; rgb < 3; rgb++) {
		for (int i = 0; i < outH; i++) {
			for (int k = 0; k < outW; k++) {
				newH = (int)(
						(i - CenterH) * Math.cos(Radian) - (k - CenterW) * Math.sin(Radian) + inH / 2);
				newW = (int)(
						(i - CenterH) * Math.sin(Radian) + (k - CenterW) * Math.cos(Radian) + inW / 2);
				if (newH < 0 || newH >= inH) {
					//Val = 255;
					outImage[0][i][k] = 55;
					outImage[1][i][k] = 59;
					outImage[2][i][k] = 68;
							
				} else if (newW < 0 || newW >= inW) {
					//Val = 255;
					outImage[0][i][k] = 55;
					outImage[1][i][k] = 59;
					outImage[2][i][k] = 68;
				} else {
					Val = inImage[rgb][newH][newW];
					outImage[rgb][i][k] = Val;
				}
				
			}
		}
	}
}
public void EmbossImage(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	double tmpInImage[][][]=new double[3][inH+2][inW+2];
	double tmpOutImage[][][]=new double[3][outH][outW];
	double[][] mask={{-1.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,1.0}};
	for(int i=0;i<inH+2;i++){
		for(int j=0;j<inW+2;j++){
			tmpInImage[0][i][j]=127.0;
			tmpInImage[1][i][j]=127.0;
			tmpInImage[2][i][j]=127.0;
		}
	}
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int j=0;j<inW;j++){
			tmpInImage[rgb][i+1][j+1]=inImage[rgb][i][j];
		}
	}
	}
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int j=0;j<inW;j++){
			double s=0;
			for(int m=0;m<3;m++){
				for(int n=0;n<3;n++){
					s+=tmpInImage[rgb][i+m][j+n]*mask[m][n];
				}
			}
			tmpOutImage[rgb][i][j]=s;
		}
	}
	}
	for(int i=0;i<outH;i++){
		for(int j=0;j<outW;j++){
			tmpOutImage[0][i][j]+=127.0;
			tmpOutImage[1][i][j]+=127.0;
			tmpOutImage[2][i][j]+=127.0;
		}
	}
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<outH;i++){
		for(int j=0;j<outW;j++){
			if(tmpOutImage[rgb][i][j]>255.0){
				outImage[rgb][i][j]=255;
			}
			else if(tmpOutImage[rgb][i][j]<0.0){
				outImage[rgb][i][j]=0;
			}
			else{
				outImage[rgb][i][j]=(int)tmpOutImage[rgb][i][j];
			}
		}
	}
	}
}
public void blurrImage(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	double tmpInImage[][][]=new double[3][inH+2][inW+2];
	double tmpOutImage[][][]=new double[3][outH][outW];
	double[][] mask={{1.0/9.0,1.0/9.0,1.0/9.0},
			{1.0/9.0,1.0/9.0,1.0/9.0},
			{1.0/9.0,1.0/9.0,1.0/9.0}};
	for(int i=0;i<inH+2;i++){
		for(int j=0;j<inW+2;j++){
			tmpInImage[0][i][j]=127.0;
			tmpInImage[1][i][j]=127.0;
			tmpInImage[2][i][j]=127.0;
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				tmpInImage[rgb][i+1][j+1]=inImage[rgb][i][j];
			}
		}
		}
		for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				double s=0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						s+=tmpInImage[rgb][i+m][j+n]*mask[m][n];
					}
				}
				tmpOutImage[rgb][i][j]=s;
			}
		}
		}
	for(int i=0;i<outH;i++){
		for(int j=0;j<outW;j++){
			tmpOutImage[0][i][j]+=127.0;
			tmpOutImage[1][i][j]+=127.0;
			tmpOutImage[2][i][j]+=127.0;
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int j=0;j<outW;j++){
				if(tmpOutImage[rgb][i][j]>255.0){
					outImage[rgb][i][j]=255;
				}
				else if(tmpOutImage[rgb][i][j]<0.0){
					outImage[rgb][i][j]=0;
				}
				else{
					outImage[rgb][i][j]=(int)tmpOutImage[rgb][i][j];
				}
			}
		}
		}
}
public void sharpening(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	double tmpInImage[][][]=new double[3][inH+2][inW+2];
	double tmpOutImage[][][]=new double[3][outH][outW];
	double[][] mask={{-1.0,-1.0,-1.0},
			{-1.0,9.0,-1.0},
			{-1.0,-1.0,-1.0}};
	for(int i=0;i<inH+2;i++){
		for(int j=0;j<inW+2;j++){
			tmpInImage[0][i][j]=127.0;
			tmpInImage[1][i][j]=127.0;
			tmpInImage[2][i][j]=127.0;
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				tmpInImage[rgb][i+1][j+1]=inImage[rgb][i][j];
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				double s=0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						s+=tmpInImage[rgb][i+m][j+n]*mask[m][n];
					}
				}
				tmpOutImage[rgb][i][j]=s;
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int j=0;j<outW;j++){
				if(tmpOutImage[rgb][i][j]>255.0){
					outImage[rgb][i][j]=255;
				}
				else if(tmpOutImage[rgb][i][j]<0.0){
					outImage[rgb][i][j]=0;
				}
				else{
					outImage[rgb][i][j]=(int)tmpOutImage[rgb][i][j];
				}
			}
		}
	}
}
public void OnHpfSharp(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	double tmpInImage[][][]=new double[3][inH+2][inW+2];
	double tmpOutImage[][][]=new double[3][outH][outW];
	double[][] mask={{-1.0/9.0,-1.0/9.0,-1.0/9.0},
			{-1.0/9.0,8.0/9.0,-1.0/9.0},
			{-1.0/9.0,-1.0/9.0,-1.0/9.0}};
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH+2;i++){
		for(int j=0;j<inW+2;j++){
			tmpInImage[rgb][i][j]=127.0;
		}
	}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				tmpInImage[rgb][i+1][j+1]=inImage[rgb][i][j];
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				double s=0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						s+=20*tmpInImage[rgb][i+m][j+n]*mask[m][n];
					}
				}
				tmpOutImage[rgb][i][j]=s;
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int j=0;j<outW;j++){
				if(tmpOutImage[rgb][i][j]>255.0){
					outImage[rgb][i][j]=255;
				}
				else if(tmpOutImage[rgb][i][j]<0.0){
					outImage[rgb][i][j]=0;
				}
				else{
					outImage[rgb][i][j]=(int)tmpOutImage[rgb][i][j];
				}
			}
		}
	}
}
public void horizon(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	double tmpInImage[][][]=new double[3][inH+2][inW+2];
	double tmpOutImage[][][]=new double[3][outH][outW];
	double[][] mask={{0.0,0.0,0.0},{-1.0,1.0,0.0},{0.0,0.0,0.0}};
	//double[][] mask={{0.0,-1.0,0.0},{0.0,1.0,0.0},{0.0,0.0,0.0}};
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH+2;i++){
		for(int j=0;j<inW+2;j++){
			tmpInImage[rgb][i][j]=127.0;
		}
	}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				tmpInImage[rgb][i+1][j+1]=inImage[rgb][i][j];
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				double s=0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						s+=tmpInImage[rgb][i+m][j+n]*mask[m][n];
					}
				}
				tmpOutImage[rgb][i][j]=s;
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int j=0;j<inW+2;j++){
				tmpInImage[rgb][i][j]+=127.0;
			}
		}
		}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int j=0;j<outW;j++){
				if(tmpOutImage[rgb][i][j]>255.0){
					outImage[rgb][i][j]=255;
				}
				else if(tmpOutImage[rgb][i][j]<0.0){
					outImage[rgb][i][j]=0;
				}
				else{
					outImage[rgb][i][j]=(int)tmpOutImage[rgb][i][j];
				}
			}
		}
	}
}
public void vertical(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	tmpInImage=new double[3][inH+2][inW+2];
	tmpOutImage=new double[3][outH][outW];
	double[][] mask={{0.0,-1.0,0.0},{0.0,1.0,0.0},{0.0,0.0,0.0}};
	//double[][] mask={{0.0,0.0,0.0},{-1.0,1.0,0.0},{0.0,0.0,0.0}};
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH+2;i++){
		for(int j=0;j<inW+2;j++){
			tmpInImage[rgb][i][j]=127.0;
		}
	}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				tmpInImage[rgb][i+1][j+1]=inImage[rgb][i][j];
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				double s=0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						s+=tmpInImage[rgb][i+m][j+n]*mask[m][n];
					}
				}
				tmpOutImage[rgb][i][j]=s;
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int j=0;j<inW+2;j++){
				tmpInImage[rgb][i][j]+=127.0;
			}
		}
		}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int j=0;j<outW;j++){
				if(tmpOutImage[rgb][i][j]>255.0){
					outImage[rgb][i][j]=255;
				}
				else if(tmpOutImage[rgb][i][j]<0.0){
					outImage[rgb][i][j]=0;
				}
				else{
					outImage[rgb][i][j]=(int)tmpOutImage[rgb][i][j];
				}
			}
		}
	}
}
public void gaussian(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	tmpInImage=new double[3][inH+2][inW+2];
	tmpOutImage=new double[3][outH][outW];
	double[][] mask={{1.0/16.0,1.0/8.0,1.0/16.0},
			{1.0/8.0,1.0/4.0,1.0/8.0},
			{1.0/16.0,1.0/8.0,1.0/16.0}};
	for(int i=0;i<inH+2;i++){
		for(int j=0;j<inW+2;j++){
			tmpInImage[0][i][j]=127.0;
			tmpInImage[1][i][j]=127.0;
			tmpInImage[2][i][j]=127.0;
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				tmpInImage[rgb][i+1][j+1]=inImage[rgb][i][j];
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				double s=0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						s+=tmpInImage[rgb][i+m][j+n]*mask[m][n];
					}
				}
				tmpOutImage[rgb][i][j]=s;
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int j=0;j<outW;j++){
				if(tmpOutImage[rgb][i][j]>255.0){
					outImage[rgb][i][j]=255;
				}
				else if(tmpOutImage[rgb][i][j]<0.0){
					outImage[rgb][i][j]=0;
				}
				else{
					outImage[rgb][i][j]=(int)tmpOutImage[rgb][i][j];
				}
			}
		}
	}
}
public void onHomogenOperator(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	tmpInImage=new double[3][inH+2][inW+2];
	tmpOutImage=new double[3][outH][outW];
	for(int i=0;i<inH+2;i++){
		for(int j=0;j<inW+2;j++){
			tmpInImage[0][i][j]=127.0;
			tmpInImage[1][i][j]=127.0;
			tmpInImage[2][i][j]=127.0;
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				tmpInImage[rgb][i+1][j+1]=inImage[rgb][i][j];
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int j=0;j<inW;j++){
			double max=0.0;
			for(int m=0;m<3;m++){
				for(int n=0;n<3;n++){
					if(Math.abs(tmpInImage[rgb][i+1][j+1]-tmpInImage[rgb][i+m][j+n])>=max)
						max=Math.abs(tmpInImage[rgb][i+1][j+1]-tmpInImage[rgb][i+m][j+n]);
				}
			}
			tmpOutImage[rgb][i][j]=max;
		}
	}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int j=0;j<outW;j++){
				if(tmpOutImage[rgb][i][j]>255.0){
					outImage[rgb][i][j]=255;
				}
				else if(tmpOutImage[rgb][i][j]<0.0){
					outImage[rgb][i][j]=0;
				}
				else{
					outImage[rgb][i][j]=(int)tmpOutImage[rgb][i][j];
				}
			}
		}
	}

}
public void laplacian(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	tmpInImage=new double[3][inH+2][inW+2];
	tmpOutImage=new double[3][outH][outW];
	double[][] mask={{0.0,1.0,0.0},
			{1.0,-4.0,1.0},
			{0.0,1.0,0.0}};
	for(int i=0;i<inH+2;i++){
		for(int j=0;j<inW+2;j++){
			tmpInImage[0][i][j]=127.0;
			tmpInImage[1][i][j]=127.0;
			tmpInImage[2][i][j]=127.0;
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				tmpInImage[rgb][i+1][j+1]=inImage[rgb][i][j];
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int j=0;j<inW;j++){
				double s=0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						s+=tmpInImage[rgb][i+m][j+n]*mask[m][n];
					}
				}
				tmpOutImage[rgb][i][j]=s;
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int j=0;j<outW;j++){
				if(tmpOutImage[rgb][i][j]>255.0){
					outImage[rgb][i][j]=255;
				}
				else if(tmpOutImage[rgb][i][j]<0.0){
					outImage[rgb][i][j]=0;
				}
				else{
					outImage[rgb][i][j]=(int)tmpOutImage[rgb][i][j];
				}
			}
		}
	}
}
public void stretchImage(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	int low=inImage[0][0][0];
	int high=inImage[0][0][0];
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			if(low>inImage[rgb][i][k]) low=inImage[rgb][i][k];
			if(high<inImage[rgb][i][k]) high=inImage[rgb][i][k];
		}
	}
	}
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			float output=((inImage[rgb][i][k]-low)*255)/(high-low);
			if(output<0.0f) {output=0;}
			else if (output>255.0f) {output=255;}
			else {outImage[rgb][i][k]=(int)output;}
		}
	}
	}
}
public void endInImage(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	int low=inImage[0][0][0];
	int high=inImage[0][0][0];
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			if(low>inImage[rgb][i][k]) low=inImage[rgb][i][k];
			if(high<inImage[rgb][i][k]) high=inImage[rgb][i][k];
		}
	}
	}
	low+=50;
	high+=50;
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			float output=((inImage[rgb][i][k]-low)*255)/(high-low);
			if(output<0.0f) {output=0;}
			else if (output>255.0f) {output=255;}
			else {outImage[rgb][i][k]=(int)output;}
		}
	}
	}
}
public void equalizeImage(){
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	int histoR[]=new int[256];
	int histoG[]=new int[256];
	int histoB[]=new int[256];
	for(int i=0;i<256;i++) {
		histoR[i]=0;
		histoG[i]=0;
		histoB[i]=0;
	}
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			histoR[inImage[0][i][k]]++;
			histoG[inImage[1][i][k]]++;
			histoB[inImage[2][i][k]]++;
		}
	}
	int sumhistoR[]=new int[256];
	int sumhistoG[]=new int[256];
	int sumhistoB[]=new int[256];
	for(int i=0;i<256;i++) {
		sumhistoR[i]=0;
		sumhistoG[i]=0;
		sumhistoB[i]=0;
	}
	int sumvalueR=0;
	int sumvalueG=0;
	int sumvalueB=0;
	for(int i=0;i<256;i++){
		sumvalueR+=histoR[i];
		sumhistoR[i]=sumvalueR;
		sumvalueG+=histoG[i];
		sumhistoG[i]=sumvalueG;
		sumvalueB+=histoB[i];
		sumhistoB[i]=sumvalueB;
	}
	double normalhistoR[]=new double[256];
	double normalhistoG[]=new double[256];
	double normalhistoB[]=new double[256];
	for(int i=0;i<256;i++){
		normalhistoR[i]=0.0;
		normalhistoG[i]=0.0;
		normalhistoB[i]=0.0;
	}
	for(int i=0;i<256;i++){
		double normalR=sumhistoR[i]*(1.0/(inH*inW))*255.0;
		normalhistoR[i]=normalR;
		double normalG=sumhistoG[i]*(1.0/(inH*inW))*255.0;
		normalhistoG[i]=normalG;
		double normalB=sumhistoB[i]*(1.0/(inH*inW))*255.0;
		normalhistoB[i]=normalB;
	}
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			outImage[0][i][k]=(int)normalhistoR[inImage[0][i][k]];
			outImage[1][i][k]=(int)normalhistoG[inImage[1][i][k]];
			outImage[2][i][k]=(int)normalhistoB[inImage[2][i][k]];
		}
	}
}
public double[] rgb2hsv(double r,double g,double b) {
	double max1 = Math.max(r,g);
	double max2=  Math.max(g,b);
	double max=(Math.max(max1,max2));
	double min1 = Math.min(r, g);
	double min2 = Math.min(g,b);
	double min=(Math.min(min1,min2));
	double d = max - min;
	double h=0,s;
     if(max==0){
    	 s=0;
     }
     else{
    	 s=d/max;
     }
     double v = max / 255;
     if(max==r){
    	h = (g - b) + d * (g < b ? 6: 0); h /= 6 * d;
     }
     else if(max==g){
    	 h = (b - r) + d * 2; h /= 6 * d;
     }     
     else if(max==b){
    	 h = (r - g) + d * 4; h /= 6 * d;
     }
     else if(max==min){
    	  h=0;
     }
    hsv[0]=(double)h;
    hsv[1]=(double)s;
    hsv[2]=(double)v;
    return hsv;
  }
public double[] hsv2rgb(double h, double s, double v) {
	double f, p, q, t;
    h = h*360;  s = s*100;    v = v*100;
    double r=0;
    double g=0;
    double b=0;
    h = Math.max(0, Math.min(360, h));
    s = Math.max(0, Math.min(100, s));
    v = Math.max(0, Math.min(100, v));
    h /= 360;   s /= 100;     v /= 100;
    int i =(int) Math.floor(h * 6);
    f = h * 6 - i;
    p = v * (1 - s);
    q = v * (1 - f * s);
    t = v * (1 - (1 - f) * s);
    if(i % 6==0) {
    	r = v; g = t; b = p;
    }
    else if(i%6==1){
    	r = q;
    	g = v;
    	b = p;
    }
    else if(i%6==2){
    	r = p;
    	g = v;
    	b = t;
    }
    else if(i%6==3){
    	r = p;
    	g = q;
    	b = v;
    }
    else if(i%6==4){
    	 r = t;
    	 g = p;
    	 b = v;
    } 
    else if(i%6==5){
    	 r = v;
    	 g = p;
    	 b = q;
    }
    rgb[0]= Math.round(r * 255);
    rgb[1]= Math.round(g* 255);
    rgb[2]= Math.round(b* 255);
    return rgb;

}
public void saturImage(){ //rgb->hsv
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
    double s_value =Double.parseDouble(para1);
     for (int i=0; i<inH; i++) {
         for (int k=0; k<inW; k++) {
                double R = inImage[0][i][k];
                double G = inImage[1][i][k];
                double B = inImage[2][i][k];
                // RGB --> HSV
                abc = rgb2hsv(R,G,B); // { h:0~360, s:0~1.0, v:0~1.0}
                double H = abc[0];
                double S = abc[1];
                double V = abc[2];
                // 채도를 변경
                S = S + s_value;
                // HSV --> RGB
                def = hsv2rgb(H,S,V);
                int R1 = (int)def[0];
                int G1 = (int)def[1];
                int B1 = (int)def[2];
                // 출력 영상에 넣기
                outImage[0][i][k] = R1;
                outImage[1][i][k] = G1;
                outImage[2][i][k] = B1;
            }
        }
}
public void orangeImage(){ // 오렌지추출(컴퓨터비전)
        // (중요!) 출력 이미지의 크기가 결정 ---> 알고리즘에 의존...
        outH=inH;
		outW=inW;
		outImage=new int[3][outH][outW];
        // **** 진짜 영상처리 알고리즘 *****
        for (int i=0; i<inH; i++) {
            for (int k=0; k<inW; k++) {
            	int R = inImage[0][i][k];
            	int G = inImage[1][i][k];
            	int B = inImage[2][i][k];
                // RGB --> HSV
                double[] efg = rgb2hsv(R,G,B); // { h:0~360, s:0~1.0, v:0~1.0}
                double H = efg[0];
                double S = efg[1];
                double V = efg[2];
                //h값에 따른 범위 추출 예) 오렌지 8~30(0~360)
                if(8<=(H*360) && (H*360)<30){ //오렌지는 그대로 두기
                    outImage[0][i][k]=R;
                    outImage[1][i][k]=G;
                    outImage[2][i][k]=B;
                }else{ //나머지는 회색영상
                	int hap=R+G+B;
                	int avg=((R+G+B)/3);
                    outImage[0][i][k]=avg;
                    outImage[1][i][k]=avg;
                    outImage[2][i][k]=avg;
                }
            }
        }
}
public void redImage(){ // 빨간색추출(컴퓨터비전)
    // (중요!) 출력 이미지의 크기가 결정 ---> 알고리즘에 의존...
    outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
    // **** 진짜 영상처리 알고리즘 *****
    for (int i=0; i<inH; i++) {
        for (int k=0; k<inW; k++) {
        	int R = inImage[0][i][k];
        	int G = inImage[1][i][k];
        	int B = inImage[2][i][k];
            // RGB --> HSV
            double[] efg = rgb2hsv(R,G,B); // { h:0~360, s:0~1.0, v:0~1.0}
            double H = efg[0];
            double S = efg[1];
            double V = efg[2];
            //h값에 따른 범위 추출 예) 오렌지 8~30(0~360)
            if((0<=(H*360) && (H*360)<15)||((H*360)>330)){ 
                outImage[0][i][k]=R;
                outImage[1][i][k]=G;
                outImage[2][i][k]=B;
            }else{ //나머지는 회색영상
            	int hap=R+G+B;
            	int avg=((R+G+B)/3);
                outImage[0][i][k]=avg;
                outImage[1][i][k]=avg;
                outImage[2][i][k]=avg;
            }
        }
    }
}
public void yellowImage(){ // 노란색추출(컴퓨터비전)
    // (중요!) 출력 이미지의 크기가 결정 ---> 알고리즘에 의존...
    outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
    // **** 진짜 영상처리 알고리즘 *****
    for (int i=0; i<inH; i++) {
        for (int k=0; k<inW; k++) {
        	int R = inImage[0][i][k];
        	int G = inImage[1][i][k];
        	int B = inImage[2][i][k];
            // RGB --> HSV
				double[] efg = rgb2hsv(R,G,B); // { h:0~360, s:0~1.0, v:0~1.0}
                double H = efg[0];
                double S = efg[1];
                double V = efg[2];
            //h값에 따른 범위 추출 예) 오렌지 8~30(0~360)
            if(35<=(H*360) && (H*360)<75){ //노란색은 그대로 두기{ 
                outImage[0][i][k]=R;
                outImage[1][i][k]=G;
                outImage[2][i][k]=B;
            }else{ //나머지는 회색영상
            	int hap=R+G+B;
            	int avg=((R+G+B)/3);
                outImage[0][i][k]=avg;
                outImage[1][i][k]=avg;
                outImage[2][i][k]=avg;
            }
        }
    }
}
public void greenImage(){ // 초록색추출(컴퓨터비전)
    // (중요!) 출력 이미지의 크기가 결정 ---> 알고리즘에 의존...
    outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
    // **** 진짜 영상처리 알고리즘 *****
    for (int i=0; i<inH; i++) {
        for (int k=0; k<inW; k++) {
        	int R = inImage[0][i][k];
        	int G = inImage[1][i][k];
        	int B = inImage[2][i][k];
            // RGB --> HSV
            double[] efg = rgb2hsv(R,G,B); // { h:0~360, s:0~1.0, v:0~1.0}
                double H = efg[0];
                double S = efg[1];
                double V = efg[2];
            //h값에 따른 범위 추출 예) 오렌지 8~30(0~360)
            if(75<=(H*360) && (H*360)<150){ //초록색는 그대로 두기
                outImage[0][i][k]=R;
                outImage[1][i][k]=G;
                outImage[2][i][k]=B;
            }else{ //나머지는 회색영상
            	int hap=R+G+B;
            	int avg=((R+G+B)/3);
                outImage[0][i][k]=avg;
                outImage[1][i][k]=avg;
                outImage[2][i][k]=avg;
            }
        }
    }
}
public void blueImage(){ // 파란색추출(컴퓨터비전)
    // (중요!) 출력 이미지의 크기가 결정 ---> 알고리즘에 의존...
    outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
    // **** 진짜 영상처리 알고리즘 *****
    for (int i=0; i<inH; i++) {
        for (int k=0; k<inW; k++) {
        	int R = inImage[0][i][k];
        	int G = inImage[1][i][k];
        	int B = inImage[2][i][k];
            // RGB --> HSV
            double[] efg = rgb2hsv(R,G,B); // { h:0~360, s:0~1.0, v:0~1.0}
                double H = efg[0];
                double S = efg[1];
                double V = efg[2];
            //h값에 따른 범위 추출 예) 오렌지 8~30(0~360)
            if(200<=(H*360) && (H*360)<255){ //오렌지는 그대로 두기
                outImage[0][i][k]=R;
                outImage[1][i][k]=G;
                outImage[2][i][k]=B;
            }else{ //나머지는 회색영상
            	int hap=R+G+B;
            	int avg=((R+G+B)/3);
                outImage[0][i][k]=avg;
                outImage[1][i][k]=avg;
                outImage[2][i][k]=avg;
            }
        }
    }
}
public void purpleImage(){ // 보라색추출(컴퓨터비전)
    // (중요!) 출력 이미지의 크기가 결정 ---> 알고리즘에 의존...
    outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
    // **** 진짜 영상처리 알고리즘 *****
    for (int i=0; i<inH; i++) {
        for (int k=0; k<inW; k++) {
        	int R = inImage[0][i][k];
        	int G = inImage[1][i][k];
        	int B = inImage[2][i][k];
            // RGB --> HSV
            double[] efg = rgb2hsv(R,G,B); // { h:0~360, s:0~1.0, v:0~1.0}
                double H = efg[0];
                double S = efg[1];
                double V = efg[2];
            //h값에 따른 범위 추출 예) 오렌지 8~30(0~360)
            if(270<=(H*360) && (H*360)<310){ //오렌지는 그대로 두기
                outImage[0][i][k]=R;
                outImage[1][i][k]=G;
                outImage[2][i][k]=B;
            }else{ //나머지는 회색영상
            	int hap=R+G+B;
            	int avg=((R+G+B)/3);
                outImage[0][i][k]=avg;
                outImage[1][i][k]=avg;
                outImage[2][i][k]=avg;
            }
        }
    }
}
%>
<%
///////////////////////
// 메인 코드부
///////////////////////
// (0) 파라미터 넘겨 받기
MultipartRequest multi=new MultipartRequest(request,"C:/Upload",
		5*1024*1024,"utf-8",new DefaultFileRenamePolicy());
String tmp;
Enumeration params=multi.getParameterNames(); //주의! 파라미터 순서가 반대
tmp=(String)params.nextElement();
para2=multi.getParameter(tmp); //55
tmp=(String)params.nextElement();
para1=multi.getParameter(tmp); //55
tmp=(String)params.nextElement();
algo=multi.getParameter(tmp); //55
//File
Enumeration files=multi.getFileNames(); //여러개 파일 연동 가능
tmp=(String) files.nextElement(); ///첫 파일 한개
String filename=multi.getFilesystemName(tmp);//파일명 추출


// (1)입력 영상 파일 처리
inFp = new File("c:/Upload/"+filename);
BufferedImage bImage=ImageIO.read(inFp);
// (2) 파일을 메모리로
// (중요!) 입력 영상의 폭과 높이를 알아내야 함! 우리가 생각하는 폭과 높이가 달라 다를 수 있음.
inW=bImage.getHeight();
inH=bImage.getWidth();

// 메모리 할당
inImage = new int[3][inH][inW];

// 읽어오기
for(int i=0; i<inH; i++) {
	for (int k=0; k<inW; k++) {
		int rgb=bImage.getRGB(i,k); //f377d6으로 r,g,b가 들어있음
		int r=(rgb>>16) & 0xFF; //f377d6(2byte 오른쪽 이동)->0000f3&0000ff->f3
		int g=(rgb>>8) & 0xFF;//1btye-->00f377 &0000ff-->77
		int b=(rgb>>0) & 0xff; //0byte-->f377d6&0000ff->d6
		
		//0x11110011&& 11111111->f3
		inImage[0][i][k] =r;
		inImage[1][i][k] =g;
		inImage[2][i][k] =b;
	}
}

// Image Processing
switch (algo) {
	case "101" :
		reverseImage(); break;
	case "102" :
		addImage(); break;
	case "103":
		grayScaleImage();break;
	case "104" :
		blackwhiteImage(); break;
	case "105":
		equalImage();break;
	case "106":
		gammaImage();break;
	case "107":
		paraCap();break;
	case "108":
		paraCup();break;
	case "109":
		updownImage();break;
	case "110":
		leftrightImage();break;
	case "111":
		zoonInImage();break;
	case "112":
		zoomOutImage();break;
	case "113":
		moveImage();break;
	case "114":
		rotateImage();break;
	case "115":
		EmbossImage();break;
	case "116":
		blurrImage();break;
	case "117":
		sharpening();break;
	case "118":
		OnHpfSharp();break;	
	case "119":
		horizon();break;
	case "120":
		vertical();break;
	case "121":
		gaussian();break;	
	case "122":
		onHomogenOperator();break;	
	case "123":
		laplacian();break;	
	case "124":
		stretchImage();break;	
	case "125":
		endInImage();break;
	case "126":
		equalizeImage();break;
	case "127":
		saturImage();break;
	case "128":
		orangeImage();break;
	case "129":
		redImage();break;
	case "130":
		yellowImage();break;
	case "131":
		greenImage();break;
	case "132":
		blueImage();break;
	case "133":
		purpleImage();break;
	case "134":
		zoonInImage1();break;
}

//(4) 결과를 파일로 저장하기
outFp = new File("c:/out/out_"+filename);
BufferedImage oImage=new BufferedImage(outH,outW,BufferedImage.TYPE_INT_RGB); //빈영상
//Memory --> File

for (int i=0; i< outH; i++) {
	for (int k=0; k<outW; k++) {
		int r=outImage[0][i][k]; //f3
		int g=outImage[1][i][k]; //77
		int b=outImage[2][i][k]; //d6
		int px=0;
		px=px | (r<<16); //000000|(f30000)->f30000
		px=px | (g<<8); //f30000|(007700)->f37700
		px=px | (b<<0); //f37700 |(0000d6) ->f37706
		oImage.setRGB(i,k,px);
	}
}
ImageIO.write(oImage,"jpg",outFp);

out.println("<h1>" + filename + " 영상 처리 완료 !! </h1>");
String url="<p><h2><a href='http://192.168.56.101:8080/";
url += "GrayImageProcessing/download.jsp?file="; 
url += "out_" + filename + "'> !! 다운로드 !! </a></h2>";
out.println(url);
%>
</body>
</html>
