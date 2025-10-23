module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Compute bitwise-OR of input vectors a and b
    assign out_or_bitwise = a | b;

    // Compute logical-OR of input vectors a and b
    // Check if any bit in either vector is 1
    assign out_or_logical = (a!= 3'b000) || (b!= 3'b000);

    // Compute inverse (NOT) of both input vectors
    // Place the inverse of b in the upper half of out_not (bits [5:3])
    // and the inverse of a in the lower half (bits [2:0])
    assign out_not = {~b, ~a};

endmodule