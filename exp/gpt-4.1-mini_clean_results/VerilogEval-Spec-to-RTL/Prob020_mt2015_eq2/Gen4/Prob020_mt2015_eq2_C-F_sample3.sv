module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Bitwise XNOR of A and B, then AND reduction to check if all bits match
assign z = & ~(A ^ B);

endmodule