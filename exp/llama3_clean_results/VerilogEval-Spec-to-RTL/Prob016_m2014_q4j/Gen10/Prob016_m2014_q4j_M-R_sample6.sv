// Full Adder module remains the same for consistency and efficiency
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// New FourBitAdder module encapsulating the full adder chain
module FourBitAdder(a, b, sum);
    input [3:0] a, b;
    output [4:0] sum;
    
    wire c1, c2, c3;
    
    FullAdder fa0(a[0], b[0], 1'b0, sum[0], c1);
    FullAdder fa1(a[1], b[1], c1, sum[1], c2);
    FullAdder fa2(a[2], b[2], c2, sum[2], c3);
    FullAdder fa3(a[3], b[3], c3, sum[3], sum[4]);
endmodule

// TopModule now simply instantiates the FourBitAdder
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    FourBitAdder adder(x, y, sum);
endmodule