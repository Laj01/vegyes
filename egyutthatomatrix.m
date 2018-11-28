
A=[0 0 0 0 1;
  (1/4)^4 (1/4)^3 (1/4)^2 (1/4) 1;
  (1/2)^4 (1/2)^3 (1/2)^2 (1/2) 1;
  (3/4)^4 (3/4)^3 (3/4)^2 (3/4) 1;
  1 1 1 1 1]

B=[0 0 0 0 1;
  (1/10)^4 (1/10)^3 (1/10)^2 (1/10) 1;
  (2/7)^4 (2/7)^3 (2/7)^2 (2/7) 1;
  (2/3)^4 (2/3)^3 (2/3)^2 (2/3) 1;
  1 1 1 1 1]

a=[-2; -1; 0; 1; 2]
b=[3; 5; 2; -1; 3]
megoldas1= A\a
megoldas2= A\b
megoldas3= B\a
megoldas4= B\b
t=linspace(0,1);
x1=megoldas1(1)*t.^4+megoldas1(2)*t.^3+megoldas1(3)*t.^2+megoldas1(4)*t+megoldas1(5);
y1=megoldas2(1)*t.^4+megoldas2(2)*t.^3+megoldas2(3)*t.^2+megoldas2(4)*t+megoldas2(5);
x2=megoldas3(1)*t.^4+megoldas3(2)*t.^3+megoldas3(3)*t.^2+megoldas3(4)*t+megoldas3(5);
y2=megoldas4(1)*t.^4+megoldas4(2)*t.^3+megoldas4(3)*t.^2+megoldas4(4)*t+megoldas4(5);
plot(x1,y1,x2,y2)