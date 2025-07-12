module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire bit_eq0;
wire bit_eq1;

// XNOR each bit of A and B: 1 if equal
assign bit_eq0 = ~(A[0] ^ B[0]);
assign bit_eq1 = ~(A[1] ^ B[1]);

// AND the bit equality results: z=1 only if all bits are equal
assign z = bit_eq0 & bit_eq1;

endmodule