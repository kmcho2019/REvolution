module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Split the input vector into individual bytes
    wire [7:0] byte0;
    wire [7:0] byte1;
    wire [7:0] byte2;
    wire [7:0] byte3;

    assign byte0 = in[7:0];
    assign byte1 = in[15:8];
    assign byte2 = in[23:16];
    assign byte3 = in[31:24];

    // Reverse the order of the bytes and concatenate them to form the output vector
    assign out = {byte3, byte2, byte1, byte0};

endmodule