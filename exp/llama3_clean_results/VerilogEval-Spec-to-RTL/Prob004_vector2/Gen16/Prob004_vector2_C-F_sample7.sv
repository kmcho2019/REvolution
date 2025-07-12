module TopModule #(
    parameter WIDTH = 32,  // Total width of the vector
    parameter NUM_BYTES = WIDTH / 8  // Number of bytes in the vector
)(
    input  wire [WIDTH-1:0] in,  // Input vector
    output wire [WIDTH-1:0] out  // Output vector with bytes reversed
);

    // Directly reverse the byte order using bitwise operations
    // This is a more generalized version of the operation in Example 2
    // It can handle vectors of any length that is a multiple of 8 bits
    genvar i;
    generate
        for (i = 0; i < NUM_BYTES; i++) begin
            // For each byte, assign it to its reversed position
            assign out[(i * 8) +: 8] = in[((NUM_BYTES - 1 - i) * 8) +: 8];
        end
    endgenerate

endmodule