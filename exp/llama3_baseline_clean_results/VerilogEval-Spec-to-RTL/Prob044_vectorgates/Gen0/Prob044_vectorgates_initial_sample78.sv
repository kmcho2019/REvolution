module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

// Perform bitwise-OR operation on input vectors a and b
assign out_or_bitwise = a | b;

// Perform logical-OR operation on input vectors a and b
assign out_or_logical = (a != 3'b0) || (b != 3'b0);

// Perform bitwise-NOT operation on input vectors a and b
assign out_not[5:3] = ~b;  // Inverse of b in upper half
assign out_not[2:0] = ~a;  // Inverse of a in lower half

endmodule