module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    assign out[7:0]   = in[24:31];
    assign out[15:8]  = in[16:23];
    assign out[23:16] = in[8:15];
    assign out[31:24] = in[0:7];

endmodule