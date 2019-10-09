(* ::Package:: *)

Needs["DatabaseLink`"];
SetDirectory["/home/Sierra/Data"];
cinna =NetModel["OpenFace Face Recognition Net Trained on CASIA-WebFace and FaceScrub Data"];
listy=FileNames["*",{Directory[]},{2}];
conn=OpenSQLConnection[JDBC["PostgreSQL",":5432/Sierra"],"Name"->"Sierra","Username"->"Sierra","Password"->"DrellaVU42"];
prevName="lol";
id=0;
For[i=2,i<=Length[listy]-1,i++,
elem=listy[[i]];
name=FileNameTake[elem,{-2}];
nextName=FileNameTake[listy[[i+1]],{-2}];
path=elem;
pic=Import[path];
pic=FindFaces[pic,"Image"];
pic=Rasterize[pic[[1]],RasterSize->{96,96}];
featureV=cinna[pic];
featureV=ToString[featureV];
If[(name==prevName||name==nextName),
If[prevName!=name,
id++];
SQLInsert[conn,"class2",{"name","path","id","featurev"},{name,path,id,featureV}];
];
prevName=name;
];
CloseSQLConnection[conn];
