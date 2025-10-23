module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire bit0_eq, bit1_eq;

// XOR is 0 if bits are equal, so invert XOR to get equality per bit
assign bit0_eq = ~(A[0] ^ B[0]);
assign bit1_eq = ~(A[1] ^ B[1]);

// Output is high only if both bits are equal
assign z = bit0_eq & bit1_eq;

endmodule