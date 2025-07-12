module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

// Compute bitwise-OR of a and b
assign out_or_bitwise = a | b;

// Compute logical-OR of a and b
assign out_or_logical = (a != 0) || (b != 0);

// Compute inverse of a and b, and concatenate them
assign out_not = {~b, ~a};

endmodule