module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    wire axorb = a ^ b;
    assign sum = axorb ^ cin;
    assign cout = (a & b) | (axorb & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] c;  // Carry chain
    
    // Ripple-carry for all bits
    FullAdder fa0(x[0], y[0], 1'b0, sum[0], c[0]);
    FullAdder fa1(x[1], y[1], c[0], sum[1], c[1]);
    FullAdder fa2(x[2], y[2], c[1], sum[2], c[2]);
    FullAdder fa3(x[3], y[3], c[2], sum[3], c[3]);
    
    // Final carry-out becomes sum[4]
    assign sum[4] = c[3];
endmodule