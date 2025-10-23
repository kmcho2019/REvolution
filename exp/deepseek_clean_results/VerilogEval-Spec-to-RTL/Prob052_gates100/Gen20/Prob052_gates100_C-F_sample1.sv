module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameters for configurable hierarchy
    localparam TOTAL_BITS = 100;
    localparam SLICE_SIZE = 25;  // Balanced 4-slice structure
    localparam SLICE_COUNT = TOTAL_BITS / SLICE_SIZE;

    // AND operation: Hierarchical reduction
    wire [SLICE_COUNT-1:0] and_slices;
    generate
        for (genvar i = 0; i < SLICE_COUNT; i = i + 1) begin : and_slices_gen
            assign and_slices[i] = &in[(i+1)*SLICE_SIZE-1 : i*SLICE_SIZE];
        end
    endgenerate
    assign out_and = &and_slices;

    // OR operation: Hierarchical reduction
    wire [SLICE_COUNT-1:0] or_slices;
    generate
        for (genvar i = 0; i < SLICE_COUNT; i = i + 1) begin : or_slices_gen
            assign or_slices[i] = |in[(i+1)*SLICE_SIZE-1 : i*SLICE_SIZE];
        end
    endgenerate
    assign out_or = |or_slices;

    // XOR operation: Single reduction (most efficient)
    assign out_xor = ^in;

endmodule