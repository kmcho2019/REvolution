// Full Adder module remains the same for its efficiency
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// New module for the 4-bit adder
module FourBitAdder(a, b, sum);
    input [3:0] a;
    input [3:0] b;
    output [4:0] sum;
    
    wire [3:0] carry;
    
    assign carry[0] = 1'b0;
    FullAdder fa0(a[0], b[0], carry[0], sum[0], carry[1]);
    FullAdder fa1(a[1], b[1], carry[1], sum[1], carry[2]);
    FullAdder fa2(a[2], b[2], carry[2], sum[2], carry[3]);
    FullAdder fa3(a[3], b[3], carry[3], sum[3], sum[4]);
endmodule

// TopModule now instantiates the FourBitAdder
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    FourBitAdder fba(x, y, sum);
endmodule