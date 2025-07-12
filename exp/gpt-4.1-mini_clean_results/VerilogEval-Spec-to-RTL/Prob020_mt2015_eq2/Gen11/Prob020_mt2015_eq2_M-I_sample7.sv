module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire bit0_eq, bit1_eq;

// Explicit bitwise equality using XNOR gates
assign bit0_eq = ~(A[0] ^ B[0]);
assign bit1_eq = ~(A[1] ^ B[1]);

// Final output is AND of bitwise equalities
assign z = bit0_eq & bit1_eq;

endmodule