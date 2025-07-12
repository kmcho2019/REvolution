module TopModule(
    input  [31:0] in,
    output [31:0] out
);

assign out = { in[0 +: 8], in[8 +: 8], in[16 +: 8], in[24 +: 8] };

endmodule