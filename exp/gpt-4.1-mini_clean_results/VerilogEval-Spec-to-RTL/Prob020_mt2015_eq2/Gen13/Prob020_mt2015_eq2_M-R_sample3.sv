module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire bit_eq0 = ~(A[0] ^ B[0]); // bitwise XNOR for bit 0
wire bit_eq1 = ~(A[1] ^ B[1]); // bitwise XNOR for bit 1

// z is 1 only if both bits match (AND of bitwise equality)
assign z = bit_eq0 & bit_eq1;

endmodule