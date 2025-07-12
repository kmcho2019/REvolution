module ByteReversalModule(
    input  wire [7:0] in,  // Input byte
    output wire [7:0] out  // Output byte (same as input)
);

    assign out = in;  // Simply pass through the input byte

endmodule

module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    wire [7:0] byte0, byte1, byte2, byte3;  // Intermediate bytes

    ByteReversalModule byte_module0(.in(in[31:24]), .out(byte0));  // Reverse first byte
    ByteReversalModule byte_module1(.in(in[23:16]), .out(byte1));  // Reverse second byte
    ByteReversalModule byte_module2(.in(in[15:8]), .out(byte2));   // Reverse third byte
    ByteReversalModule byte_module3(.in(in[7:0]), .out(byte3));     // Reverse fourth byte

    assign out = {byte3, byte2, byte1, byte0};  // Concatenate reversed bytes

endmodule