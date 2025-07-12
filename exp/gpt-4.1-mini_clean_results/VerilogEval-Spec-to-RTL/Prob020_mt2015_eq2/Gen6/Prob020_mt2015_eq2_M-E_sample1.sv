module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire bit_equal0;
wire bit_equal1;

assign bit_equal0 = ~(A[0] ^ B[0]); // XNOR for bit 0
assign bit_equal1 = ~(A[1] ^ B[1]); // XNOR for bit 1

assign z = bit_equal0 & bit_equal1; // AND of XNOR results

endmodule