module TopModule (
    input  wire [31:0] in,
    output wire [31:0] out
);

    wire [7:0] byte0;
    wire [7:0] byte1;
    wire [7:0] byte2;
    wire [7:0] byte3;

    assign byte0 = in[7:0];
    assign byte1 = in[15:8];
    assign byte2 = in[23:16];
    assign byte3 = in[31:24];

    assign out = {byte3, byte2, byte1, byte0};

endmodule