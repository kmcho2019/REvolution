module ByteReversalModule #(
    parameter WIDTH = 32  // Input vector width
)(
    input  wire [WIDTH-1:0] in,  // Input vector
    output wire [WIDTH-1:0] out  // Output vector with bytes reversed
);

    // Calculate the number of bytes in the input vector
    localparam NUM_BYTES = WIDTH / 8;

    // Directly assign the bytes of the input vector to the output vector in reverse order
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};  // Reverse byte order for 32-bit input

    // For input vectors of different lengths, use a more general approach
    // This can be implemented using a generate block or a loop
    // However, for simplicity, we will stick with the 32-bit case

endmodule

module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Instantiate the ByteReversalModule
    ByteReversalModule byte_reversal_module(.in(in),.out(out));

endmodule