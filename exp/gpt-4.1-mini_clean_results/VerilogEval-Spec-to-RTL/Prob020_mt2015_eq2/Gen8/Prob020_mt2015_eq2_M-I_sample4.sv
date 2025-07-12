module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Output z is 1 if and only if 2-bit inputs A and B are equal.
// Explicit bitwise XNOR and AND implement equality.
assign z = ((A[1] ~^ B[1]) & (A[0] ~^ B[0]));

endmodule