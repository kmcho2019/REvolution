// HalfAdder module
module HalfAdder(
    input   logic a,
    input   logic b,
    output  logic sum,
    output  logic cout
);
    
    assign sum = a ^ b;
    assign cout = a & b;
    
endmodule

// Mux2to1 module
module Mux2to1(
    input   logic a,
    input   logic b,
    input   logic sel,
    output  logic out
);
    
    assign out = sel ? b : a;
    
endmodule

// TopModule
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);
    
    wire logic cout_0, cout_1, cout_2, cout_3;
    wire logic sum_0, sum_1, sum_2, sum_3;
    
    HalfAdder ha0(x[0], y[0], sum_0, cout_0);
    Mux2to1 mux1(sum_1, x[1], cout_0, sum[1]);
    Mux2to1 mux2(sum_2, x[2], cout_1, sum[2]);
    Mux2to1 mux3(sum_3, x[3], cout_2, sum[3]);
    
    HalfAdder ha1(y[1], cout_0, sum_1, cout_1);
    HalfAdder ha2(y[2], cout_1, sum_2, cout_2);
    HalfAdder ha3(y[3], cout_2, sum_3, cout_3);
    
    assign sum[0] = sum_0;
    assign sum[4] = cout_3;
    
endmodule