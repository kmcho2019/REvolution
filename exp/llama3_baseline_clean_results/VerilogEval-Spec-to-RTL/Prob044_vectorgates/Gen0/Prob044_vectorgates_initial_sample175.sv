module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

// Compute the bitwise-OR of the two input vectors
assign out_or_bitwise = a | b;

// Calculate the logical-OR of the two vectors
assign out_or_logical = (a != 3'b000) || (b != 3'b000);

// Compute the inverse of both vectors and concatenate them
assign out_not = {~b, ~a};

endmodule