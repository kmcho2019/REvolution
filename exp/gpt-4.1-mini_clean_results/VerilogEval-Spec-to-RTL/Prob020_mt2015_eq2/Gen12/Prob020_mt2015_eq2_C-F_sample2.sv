module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Equality check by bitwise XNOR followed by AND to produce 'z' = (A == B)
wire eq_bit0, eq_bit1;

assign eq_bit0 = ~(A[0] ^ B[0]); // bit 0 equality via XNOR
assign eq_bit1 = ~(A[1] ^ B[1]); // bit 1 equality via XNOR

assign z = eq_bit0 & eq_bit1;

endmodule