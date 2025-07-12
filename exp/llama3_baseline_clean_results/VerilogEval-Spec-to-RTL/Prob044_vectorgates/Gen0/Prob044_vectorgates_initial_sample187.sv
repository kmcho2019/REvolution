module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

// Assign the bitwise-OR of a and b to out_or_bitwise
assign out_or_bitwise = a | b;

// Assign the logical-OR of a and b to out_or_logical
// We use the fact that a non-zero vector is considered true in a logical context
assign out_or_logical = (a != 0) || (b != 0);

// Assign the inverse of b to the upper half of out_not and the inverse of a to the lower half
assign out_not = {~b, ~a};

endmodule