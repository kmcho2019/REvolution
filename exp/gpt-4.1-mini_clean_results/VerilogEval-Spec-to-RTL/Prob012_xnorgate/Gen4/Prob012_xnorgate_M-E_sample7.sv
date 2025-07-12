module TopModule (
    input wire a,
    input wire b,
    output wire out
);

wire xor_out;

assign xor_out = a ^ b;
assign out = ~xor_out;

endmodule