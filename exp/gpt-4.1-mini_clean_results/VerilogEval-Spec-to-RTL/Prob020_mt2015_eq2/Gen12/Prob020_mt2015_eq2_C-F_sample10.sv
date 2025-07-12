module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// z is 1 when all bits of A and B are equal.
// Equivalent to bitwise XNOR of A and B followed by reduction AND:
// assign z = &(~(A ^ B));
assign z = (A == B);

endmodule