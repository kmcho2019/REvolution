module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    // Extracting bytes from the input vector
    wire [7:0] byte3 = in[31:24];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte1 = in[15:8];
    wire [7:0] byte0 = in[7:0];

    // Recombining the bytes in reverse order
    assign out = {byte0, byte1, byte2, byte3};

endmodule