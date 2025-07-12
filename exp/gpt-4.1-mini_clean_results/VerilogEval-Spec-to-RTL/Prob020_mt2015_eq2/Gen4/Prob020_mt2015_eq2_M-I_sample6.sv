module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire eq_bit0, eq_bit1;

assign eq_bit0 = ~(A[0] ^ B[0]); // XNOR of LSB
assign eq_bit1 = ~(A[1] ^ B[1]); // XNOR of MSB

assign z = eq_bit0 & eq_bit1;

endmodule