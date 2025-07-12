module TopModule(
    input  [2:0] a,      // 3-bit input vector
    input  [2:0] b,      // 3-bit input vector
    output [2:0] out_or_bitwise,  // bitwise-OR of a and b
    output out_or_logical,      // logical-OR of a and b
    output [5:0] out_not         // inverse of a and b
);

// Compute bitwise-OR of vectors 'a' and 'b'
assign out_or_bitwise = a | b;

// Compute logical-OR of vectors 'a' and 'b'
assign out_or_logical = (a != 3'b000) || (b != 3'b000);

// Compute inverse (NOT) of vectors 'a' and 'b'
assign out_not = {~b, ~a};

endmodule