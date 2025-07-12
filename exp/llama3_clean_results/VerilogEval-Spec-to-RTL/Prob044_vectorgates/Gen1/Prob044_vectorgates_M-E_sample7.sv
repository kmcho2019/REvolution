module TopModule(
    input  [2:0] a, 
    input  [2:0] b, 
    output [2:0] out_or_bitwise, 
    output        out_or_logical, 
    output [5:0] out_not
);

// Compute the bitwise-OR of the two input vectors
assign out_or_bitwise[0] = a[0] | b[0];
assign out_or_bitwise[1] = a[1] | b[1];
assign out_or_bitwise[2] = a[2] | b[2];

// Compute the logical-OR of the two input vectors
wire a_nonzero, b_nonzero;
assign a_nonzero = (a[0] | a[1] | a[2]) ? 1'b1 : 1'b0;
assign b_nonzero = (b[0] | b[1] | b[2]) ? 1'b1 : 1'b0;
assign out_or_logical = a_nonzero | b_nonzero;

// Compute the bitwise-NOT of both input vectors
assign out_not[5:3] = ~b;
assign out_not[2:0] = ~a;

endmodule