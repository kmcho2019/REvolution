module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // Name each byte of the input vector for clarity
    wire [7:0] byte0 = in[7:0];
    wire [7:0] byte1 = in[15:8];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte3 = in[31:24];

    // Concatenate the bytes in reversed order to form the output
    assign out = {byte0, byte1, byte2, byte3};

endmodule