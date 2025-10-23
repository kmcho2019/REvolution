module TopModule(
    input a,
    input b,
    output out
);

wire xor_out;

assign xor_out = a ^ b;
assign out = ~xor_out;

endmodule