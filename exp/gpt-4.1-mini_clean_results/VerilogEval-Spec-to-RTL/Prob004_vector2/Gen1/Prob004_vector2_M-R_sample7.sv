module TopModule(
    input  [31:0] in,
    output [31:0] out
);
    wire [7:0] byte0, byte1, byte2, byte3;

    assign byte3 = in[31:24];
    assign byte2 = in[23:16];
    assign byte1 = in[15:8];
    assign byte0 = in[7:0];

    assign out = {byte0, byte1, byte2, byte3};
endmodule