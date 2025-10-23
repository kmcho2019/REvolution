module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

assign out_or_bitwise = a | b; // Compute bitwise-OR of a and b
assign out_or_logical = (a != 3'b0) || (b != 3'b0); // Compute logical-OR of a and b
assign out_not[5:3] = ~b; // Compute inverse of b and assign to upper half of out_not
assign out_not[2:0] = ~a; // Compute inverse of a and assign to lower half of out_not

endmodule