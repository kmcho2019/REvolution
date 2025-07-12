module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Bitwise XNOR comparison for each bit pair
wire bit0_eq;
wire bit1_eq;

assign bit0_eq = ~(A[0] ^ B[0]);
assign bit1_eq = ~(A[1] ^ B[1]);

// Final output is AND of both bit equality results
assign z = bit0_eq & bit1_eq;

endmodule