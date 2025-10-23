module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output        out_or_logical,
    output [5:0] out_not
);

// Compute bitwise-OR of vectors a and b
assign out_or_bitwise = a | b;

// Compute logical-OR of vectors a and b
assign out_or_logical = (a != 0) || (b != 0);

// Compute inverse (NOT) of vectors a and b
assign out_not = {~b, ~a};

endmodule