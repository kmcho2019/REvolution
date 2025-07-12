module TopModule (
    input  logic [31:0] in,  // 32-bit input vector
    output logic [31:0] out  // 32-bit output vector with bytes reversed
);

    // Declare temporary variables to store each byte
    logic [7:0] byte0, byte1, byte2, byte3;

    // Store the individual bytes of the input vector
    assign byte0 = in[7:0];
    assign byte1 = in[15:8];
    assign byte2 = in[23:16];
    assign byte3 = in[31:24];

    // Concatenate the bytes in reverse order to form the output vector
    assign out = {byte3, byte2, byte1, byte0};

endmodule