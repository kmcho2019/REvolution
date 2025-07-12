module FullAdder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin, // carry-in bit
    output sum, // sum bit
    output cout  // carry-out bit
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module TopModule(
    input [3:0] x,  // 4-bit input
    input [3:0] y,  // 4-bit input
    output [4:0] sum // 5-bit output sum
);
    wire c1, c2, c3; // internal carry wires

    FullAdder fa0(x[0], y[0], 1'b0, sum[0], c1);
    FullAdder fa1(x[1], y[1], c1, sum[1], c2);
    FullAdder fa2(x[2], y[2], c2, sum[2], c3);
    FullAdder fa3(x[3], y[3], c3, sum[3], sum[4]);
endmodule