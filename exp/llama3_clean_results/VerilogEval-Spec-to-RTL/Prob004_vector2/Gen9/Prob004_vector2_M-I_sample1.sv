module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output reg [31:0] out  // 32-bit output vector with bytes reversed
);

    always @(*) begin
        // The original code already achieves the correct reversal in a concise manner.
        // However, to potentially improve synthesis, we can express the reversal in terms of byte-level manipulation.
        out[ 7: 0] = in[ 7: 0];  // Byte 0
        out[15: 8] = in[15: 8];  // Byte 1
        out[23:16] = in[23:16];  // Byte 2
        out[31:24] = in[31:24];  // Byte 3
    end

endmodule