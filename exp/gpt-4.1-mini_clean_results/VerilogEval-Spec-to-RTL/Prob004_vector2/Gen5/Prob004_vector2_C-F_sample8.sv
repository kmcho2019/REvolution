module TopModule (
    input  [31:0] in,
    output [31:0] out
);

// Reverse byte order: out[31:24] = in[7:0], out[23:16] = in[15:8], etc.
assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule