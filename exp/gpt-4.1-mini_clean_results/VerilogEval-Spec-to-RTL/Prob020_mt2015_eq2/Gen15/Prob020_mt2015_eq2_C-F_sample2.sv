module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Bitwise XNOR of A and B, then AND reduction: z=1 if all bits equal
assign z = &(~^(A ^ B));

endmodule