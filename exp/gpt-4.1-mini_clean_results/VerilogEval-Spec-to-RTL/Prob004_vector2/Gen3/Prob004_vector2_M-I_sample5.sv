module TopModule(
    input  [31:0] in,
    output [31:0] out
);

// Reverse byte order of 32-bit input by concatenating bytes from LSB to MSB
assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule