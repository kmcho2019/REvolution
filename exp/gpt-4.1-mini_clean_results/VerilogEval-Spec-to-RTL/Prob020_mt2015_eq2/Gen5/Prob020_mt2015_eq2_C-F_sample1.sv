module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Output z is 1 if and only if 2-bit inputs A and B are equal.
assign z = (A == B);

endmodule