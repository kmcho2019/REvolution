module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Explicit byte definitions for clarity
    wire [7:0] byte0 = in[7:0];    // LSB byte
    wire [7:0] byte1 = in[15:8];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte3 = in[31:24];  // MSB byte

    // Reverse byte order: [byte0, byte1, byte2, byte3] -> [byte3, byte2, byte1, byte0]
    assign out = {byte0, byte1, byte2, byte3};
endmodule