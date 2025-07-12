module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Parameters for group size and number of groups
    localparam GROUP_SIZE = 10;
    localparam NUM_GROUPS = 10;

    wire [NUM_GROUPS-1:0] partial_and;
    wire [NUM_GROUPS-1:0] partial_or;
    wire [NUM_GROUPS-1:0] partial_xor;

    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : group_reduction
            // Extract slice of inputs for this group
            wire [GROUP_SIZE-1:0] group_in = in[i*GROUP_SIZE +: GROUP_SIZE];

            // Compute group partial reduction results using built-in reduction ops
            assign partial_and[i] = &group_in;
            assign partial_or[i]  = |group_in;
            assign partial_xor[i] = ^group_in;
        end
    endgenerate

    // Final stage: reduce partial results to single output per signal
    assign out_and = &partial_and;
    assign out_or  = |partial_or;
    assign out_xor = ^partial_xor;

endmodule