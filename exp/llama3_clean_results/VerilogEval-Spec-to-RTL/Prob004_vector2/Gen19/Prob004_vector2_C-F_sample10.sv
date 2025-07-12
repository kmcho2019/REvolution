module ByteReversalModule #(
    parameter WIDTH = 32  // Input vector width
)(
    input  wire [WIDTH-1:0] in,  // Input vector
    output wire [WIDTH-1:0] out  // Output vector with bytes reversed
);

    // Calculate the number of bytes in the input vector
    localparam NUM_BYTES = WIDTH / 8;

    // Use a generate block to create a flexible and efficient byte reversal module
    genvar i;
    generate
        for (i = 0; i < NUM_BYTES; i++) begin
            assign out[(NUM_BYTES - 1 - i) * 8 +: 8] = in[i * 8 +: 8];
        end
    endgenerate

endmodule

module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Instantiate the ByteReversalModule
    ByteReversalModule #(.WIDTH(32)) byte_reversal_module(.in(in), .out(out));

endmodule