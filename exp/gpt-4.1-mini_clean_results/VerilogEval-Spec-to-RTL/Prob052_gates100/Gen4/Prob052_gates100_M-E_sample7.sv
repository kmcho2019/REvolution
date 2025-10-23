module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Parameters for clarity
    localparam GROUP_SIZE = 10;
    localparam NUM_GROUPS = 10;

    // Intermediate reduction results for each group
    wire [NUM_GROUPS-1:0] group_and;
    wire [NUM_GROUPS-1:0] group_or;
    wire [NUM_GROUPS-1:0] group_xor;

    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : group_reduction
            // Extract 10-bit group slice
            wire [GROUP_SIZE-1:0] group_slice = in[i*GROUP_SIZE +: GROUP_SIZE];

            // Compute reduction on the group
            assign group_and[i] = &group_slice;
            assign group_or[i]  = |group_slice;
            assign group_xor[i] = ^group_slice;
        end
    endgenerate

    // Final reduction combining the intermediate groups
    assign out_and = &group_and;
    assign out_or  = |group_or;
    assign out_xor = ^group_xor;

endmodule