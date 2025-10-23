// Half Adder module
module HalfAdder(a, b, sum, carry);
    input a, b;
    output sum, carry;
    
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

// Full Adder module using Half Adders
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    wire sum1, carry1, carry2;
    
    HalfAdder ha1(a, b, sum1, carry1);
    HalfAdder ha2(sum1, cin, sum, carry2);
    assign cout = carry1 | carry2;
endmodule

// TopModule with minor optimizations for readability and maintainability
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    wire [3:0] carry;
    
    assign carry[0] = 1'b0;
    FullAdder fa0(x[0], y[0], carry[0], sum[0], carry[1]);
    FullAdder fa1(x[1], y[1], carry[1], sum[1], carry[2]);
    FullAdder fa2(x[2], y[2], carry[2], sum[2], carry[3]);
    FullAdder fa3(x[3], y[3], carry[3], sum[3], sum[4]);
endmodule