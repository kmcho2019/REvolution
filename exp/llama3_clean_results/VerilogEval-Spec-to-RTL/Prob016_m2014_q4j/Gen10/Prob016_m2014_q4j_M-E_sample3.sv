// Half Adder module
module HalfAdder(a, b, sum, carry);
    input a, b;
    output sum, carry;
    
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

// Multiplexer module
module Mux2to1(a, b, sel, out);
    input a, b, sel;
    output out;
    
    assign out = sel ? b : a;
endmodule

// TopModule
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    wire [3:0] carry;
    wire [3:0] sum_bit;
    
    // Initialize carry and sum_bit arrays
    assign carry[0] = 1'b0;
    assign sum_bit[0] = x[0] ^ y[0];
    
    // Calculate sum and carry bits for each bit position
    HalfAdder ha0(x[0], y[0], sum_bit[0], carry[0]);
    Mux2to1 mux0(sum_bit[0], sum_bit[0], carry[0], sum[0]);
    
    HalfAdder ha1(x[1], y[1], sum_bit[1], carry[1]);
    Mux2to1 mux1(sum_bit[1], sum_bit[1], carry[1], sum[1]);
    
    HalfAdder ha2(x[2], y[2], sum_bit[2], carry[2]);
    Mux2to1 mux2(sum_bit[2], sum_bit[2], carry[2], sum[2]);
    
    HalfAdder ha3(x[3], y[3], sum_bit[3], carry[3]);
    Mux2to1 mux3(sum_bit[3], sum_bit[3], carry[3], sum[3]);
    
    // Calculate final carry bit
    assign sum[4] = carry[3];
endmodule