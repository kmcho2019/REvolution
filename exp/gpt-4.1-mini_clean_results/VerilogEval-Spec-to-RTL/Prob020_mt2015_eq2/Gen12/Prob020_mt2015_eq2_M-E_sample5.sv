module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire bit0_diff, bit1_diff;

assign bit0_diff = A[0] ^ B[0];
assign bit1_diff = A[1] ^ B[1];

assign z = ~(bit0_diff | bit1_diff);

endmodule