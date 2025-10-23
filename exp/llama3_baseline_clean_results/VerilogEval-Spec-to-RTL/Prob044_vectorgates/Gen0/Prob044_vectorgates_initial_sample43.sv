module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

assign out_or_bitwise = a | b; // Compute bitwise-OR of a and b
assign out_or_logical = (|a) || (|b); // Compute logical-OR of a and b
assign out_not[5:3] = ~b; // Assign inverse of b to upper half of out_not
assign out_not[2:0] = ~a; // Assign inverse of a to lower half of out_not

endmodule