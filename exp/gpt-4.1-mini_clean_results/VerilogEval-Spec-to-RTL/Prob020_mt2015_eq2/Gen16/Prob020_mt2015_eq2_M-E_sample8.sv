module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Compare individual bits and combine with AND to determine equality
wire bit0_eq;
wire bit1_eq;

assign bit0_eq = ~(A[0] ^ B[0]);  // XNOR of bit 0
assign bit1_eq = ~(A[1] ^ B[1]);  // XNOR of bit 1

assign z = bit0_eq & bit1_eq;     // Both bits must be equal

endmodule