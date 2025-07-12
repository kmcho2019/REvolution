module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // Reverse byte order: output bytes = {byte0, byte1, byte2, byte3}
    // where input bytes are {byte3, byte2, byte1, byte0}
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule