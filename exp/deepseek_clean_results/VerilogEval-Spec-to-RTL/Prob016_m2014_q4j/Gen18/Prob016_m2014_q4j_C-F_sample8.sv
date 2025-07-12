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
    wire [2:0] c;  // Carry chain for bits 0-2
    
    // Ripple-carry for bits 0-2
    FullAdder fa0(x[0], y[0], 1'b0, sum[0], c[0]);
    FullAdder fa1(x[1], y[1], c[0], sum[1], c[1]);
    FullAdder fa2(x[2], y[2], c[1], sum[2], c[2]);
    
    // Carry-lookahead optimized MSB
    wire g = x[3] & y[3];
    wire p = x[3] ^ y[3];
    assign sum[3] = p ^ c[2];
    assign sum[4] = g | (p & c[2]);  // Final carry-out
endmodule