// Full Adder module remains the same for its efficiency
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Simplified TopModule with direct instantiation of full adders
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    wire [2:0] carry;
    
    assign carry[0] = 1'b0;
    FullAdder fa0(x[0], y[0], carry[0], sum[0], carry[1]);
    FullAdder fa1(x[1], y[1], carry[1], sum[1], carry[2]);
    FullAdder fa2(x[2], y[2], carry[2], sum[2], carry[3]);
    FullAdder fa3(x[3], y[3], carry[3], sum[3], sum[4]);
endmodule