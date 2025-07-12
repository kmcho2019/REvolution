module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [1:0] xor_bits;

assign xor_bits = A ^ B;
assign z = ~(|xor_bits);

endmodule