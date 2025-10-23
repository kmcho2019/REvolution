// Half-Adder module
module HalfAdder(a, b, sum, cout);
    input a, b;
    output sum, cout;
    
    assign sum = a ^ b;
    assign cout = a & b;
endmodule

// Kogge-Stone Adder module
module KoggeStoneAdder(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    wire [1:0] c1, c2;
    wire [3:0] s1, s2;
    
    // Stage 1
    HalfAdder ha0(x[0], y[0], s1[0], c1[0]);
    HalfAdder ha1(x[1], y[1], s1[1], c1[1]);
    HalfAdder ha2(x[2], y[2], s1[2], c2[0]);
    HalfAdder ha3(x[3], y[3], s1[3], c2[1]);
    
    // Stage 2
    HalfAdder ha4(s1[0], s1[1], s2[0], c1[0]);
    HalfAdder ha5(c1[0], c1[1], s2[1], c1[1]);
    HalfAdder ha6(s1[2], s1[3], s2[2], c2[0]);
    HalfAdder ha7(c2[0], c2[1], s2[3], c2[1]);
    
    // Stage 3
    HalfAdder ha8(s2[0], s2[1], sum[0], sum[1]);
    HalfAdder ha9(c1[1], c2[1], sum[2], sum[3]);
    assign sum[4] = c1[1] | c2[1];
endmodule

// TopModule
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    KoggeStoneAdder ksa(x, y, sum);
endmodule