module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [1:0] xnor_bits;
assign xnor_bits = ~(A ^ B);
assign z = &xnor_bits;

endmodule