module TopModule (
    input  wire [31:0] in,
    output wire [31:0] out
);

    // Attempting to optimize by explicitly assigning each byte
    // This might help the synthesis tool find a more optimal implementation
    wire [7:0] byte0 = in[7:0];
    wire [7:0] byte1 = in[15:8];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte3 = in[31:24];

    assign out = {byte3, byte2, byte1, byte0};

endmodule