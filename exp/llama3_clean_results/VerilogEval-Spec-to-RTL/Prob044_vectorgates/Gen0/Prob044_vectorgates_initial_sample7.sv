module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

assign out_or_bitwise = a | b; // Bitwise-OR operation

// Logical-OR operation: Check if any bit in either vector is 1
assign out_or_logical = (a != 3'b000) || (b != 3'b000);

// Inverse (NOT) operation on both vectors
assign out_not[5:3] = ~b; // Inverse of b in the upper half
assign out_not[2:0] = ~a; // Inverse of a in the lower half

endmodule