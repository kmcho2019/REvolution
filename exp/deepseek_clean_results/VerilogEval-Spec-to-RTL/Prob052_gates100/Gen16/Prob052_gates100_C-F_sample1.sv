module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Configurable parameters
    localparam WIDTH = 100;
    localparam SLICE_SIZE = 25;  // Balanced 4-level tree (100/25=4)
    localparam NUM_SLICES = WIDTH / SLICE_SIZE;

    // AND operation: hierarchical reduction
    wire [NUM_SLICES-1:0] and_slices;
    generate
        for (genvar i = 0; i < NUM_SLICES; i = i + 1) begin : and_slices_gen
            assign and_slices[i] = &in[(i*SLICE_SIZE)+:SLICE_SIZE];
        end
    endgenerate
    assign out_and = &and_slices;

    // OR operation: hierarchical reduction
    wire [NUM_SLICES-1:0] or_slices;
    generate
        for (genvar i = 0; i < NUM_SLICES; i = i + 1) begin : or_slices_gen
            assign or_slices[i] = |in[(i*SLICE_SIZE)+:SLICE_SIZE];
        end
    endgenerate
    assign out_or = |or_slices;

    // XOR operation: optimal single reduction
    assign out_xor = ^in;

endmodule