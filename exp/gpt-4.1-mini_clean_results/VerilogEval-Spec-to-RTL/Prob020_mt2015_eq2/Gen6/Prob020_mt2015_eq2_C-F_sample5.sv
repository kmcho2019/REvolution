module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire eq_bit0, eq_bit1;

// Bitwise equality: XNOR each bit pair
assign eq_bit0 = ~(A[0] ^ B[0]);
assign eq_bit1 = ~(A[1] ^ B[1]);

// Output z is high only if both bits are equal
assign z = eq_bit0 & eq_bit1;

endmodule