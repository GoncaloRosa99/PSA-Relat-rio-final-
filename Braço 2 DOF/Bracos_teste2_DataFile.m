% Simscape(TM) Multibody(TM) version: 24.2

% This is a model data file derived from a Simscape Multibody Import XML file using the smimport function.
% The data in this file sets the block parameter values in an imported Simscape Multibody model.
% For more information on this file, see the smimport function help page in the Simscape Multibody documentation.
% You can modify numerical values, but avoid any other changes to this file.
% Do not add code to this file. Do not edit the physical units shown in comments.

%%%VariableName:smiData


%============= RigidTransform =============%

%Initialize the RigidTransform structure array by filling in null values.
smiData.RigidTransform(5).translation = [0.0 0.0 0.0];
smiData.RigidTransform(5).angle = 0.0;
smiData.RigidTransform(5).axis = [0.0 0.0 0.0];
smiData.RigidTransform(5).ID = "";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(1).translation = [140 0 9.9999999999999947];  % mm
smiData.RigidTransform(1).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(1).axis = [1 0 0];
smiData.RigidTransform(1).ID = "B[Bracofixo-1:-:Bracoguincho-2]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(2).translation = [-2.8421709430404007e-14 0 -10];  % mm
smiData.RigidTransform(2).angle = 0;  % rad
smiData.RigidTransform(2).axis = [0 0 0];
smiData.RigidTransform(2).ID = "F[Bracofixo-1:-:Bracoguincho-2]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(3).translation = [34.999999999999993 0.076080003226758341 -30];  % mm
smiData.RigidTransform(3).angle = 0;  % rad
smiData.RigidTransform(3).axis = [0 0 0];
smiData.RigidTransform(3).ID = "B[Fixado-1:-:Bracofixo-1]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(4).translation = [-3.5527136788005009e-15 0 -30];  % mm
smiData.RigidTransform(4).angle = 0;  % rad
smiData.RigidTransform(4).axis = [0 0 0];
smiData.RigidTransform(4).ID = "F[Fixado-1:-:Bracofixo-1]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(5).translation = [-43.030717015665729 42.206469304316819 93.832123751007728];  % mm
smiData.RigidTransform(5).angle = 0;  % rad
smiData.RigidTransform(5).axis = [0 0 0];
smiData.RigidTransform(5).ID = "RootGround[Fixado-1]";


%============= Solid =============%
%Center of Mass (CoM) %Moments of Inertia (MoI) %Product of Inertia (PoI)

%Initialize the Solid structure array by filling in null values.
smiData.Solid(3).mass = 0.0;
smiData.Solid(3).CoM = [0.0 0.0 0.0];
smiData.Solid(3).MoI = [0.0 0.0 0.0];
smiData.Solid(3).PoI = [0.0 0.0 0.0];
smiData.Solid(3).color = [0.0 0.0 0.0];
smiData.Solid(3).opacity = 0.0;
smiData.Solid(3).ID = "";

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(1).mass = 0.20743362938564075;  % kg
smiData.Solid(1).CoM = [20.537542736512187 0.01739713414552041 0];  % mm
smiData.Solid(1).MoI = [248.90729190692883 202.01970834462196 191.15118811732879];  % kg*mm^2
smiData.Solid(1).PoI = [-0.091296003872128259 0 -0.052191402436598471];  % kg*mm^2
smiData.Solid(1).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
smiData.Solid(1).opacity = 1;
smiData.Solid(1).ID = "Fixado*:*Default";

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(2).mass = 0.064751106428108912;  % kg
smiData.Solid(2).CoM = [54.263546101345781 0 0];  % mm
smiData.Solid(2).MoI = [8.6965252976395337 51.152465396838274 49.625861962423599];  % kg*mm^2
smiData.Solid(2).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(2).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
smiData.Solid(2).opacity = 1;
smiData.Solid(2).ID = "Bracoguincho*:*Default";

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(3).mass = 0.067251106428108942;  % kg
smiData.Solid(3).CoM = [69.999999999999986 0 0];  % mm
smiData.Solid(3).MoI = [5.9568728125493964 110.46646097694983 111.93992669429196];  % kg*mm^2
smiData.Solid(3).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(3).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
smiData.Solid(3).opacity = 1;
smiData.Solid(3).ID = "Bracofixo*:*Default";


%============= Joint =============%
%X Revolute Primitive (Rx) %Y Revolute Primitive (Ry) %Z Revolute Primitive (Rz)
%X Prismatic Primitive (Px) %Y Prismatic Primitive (Py) %Z Prismatic Primitive (Pz) %Spherical Primitive (S)
%Constant Velocity Primitive (CV) %Lead Screw Primitive (LS)
%Position Target (Pos)

%Initialize the RevoluteJoint structure array by filling in null values.
smiData.RevoluteJoint(2).Rz.Pos = 0.0;
smiData.RevoluteJoint(2).ID = "";

smiData.RevoluteJoint(1).Rz.Pos = 0;  % deg
smiData.RevoluteJoint(1).ID = "[Bracofixo-1:-:Bracoguincho-2]";

smiData.RevoluteJoint(2).Rz.Pos = 0;  % deg
smiData.RevoluteJoint(2).ID = "[Fixado-1:-:Bracofixo-1]";

