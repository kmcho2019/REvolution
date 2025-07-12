module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    // Split the input 32-bit vector into four 8-bit bytes
    wire [7:0] byte3 = in[31:24];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte1 = in[15:8];
    wire [7:0] byte0 = in[7:0];

    // Concatenate the bytes in reverse order to form the output vector
    assign out = {byte0, byte1, byte2, byte3};

endmodule