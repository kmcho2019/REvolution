module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Intermediate partial results for each 10-bit chunk
    wire [9:0] and_blocks;
    wire [9:0] or_blocks;
    wire [9:0] xor_blocks;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : blocks
            assign and_blocks[i] = &in[i*10 +: 10];  // Reduction AND on 10 inputs
            assign or_blocks[i]  = |in[i*10 +: 10];  // Reduction OR on 10 inputs
            assign xor_blocks[i] = ^in[i*10 +: 10];  // Reduction XOR on 10 inputs
        end
    endgenerate

    // Combine partial results to get the final outputs
    assign out_and = &and_blocks;
    assign out_or  = |or_blocks;
    assign out_xor = ^xor_blocks;

endmodule