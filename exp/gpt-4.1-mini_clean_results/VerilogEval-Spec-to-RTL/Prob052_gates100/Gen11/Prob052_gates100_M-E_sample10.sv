module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Parameters for group size and number of groups
    localparam GROUP_SIZE = 10;
    localparam NUM_GROUPS = 10;

    // Partial results arrays
    wire [NUM_GROUPS-1:0] partial_and;
    wire [NUM_GROUPS-1:0] partial_or;
    wire [NUM_GROUPS-1:0] partial_xor;

    // Stage 1: Compute reduction within each group of 10 bits
    genvar gi;
    generate
        for (gi = 0; gi < NUM_GROUPS; gi = gi + 1) begin : group_reduction
            wire [GROUP_SIZE-1:0] group_bits;
            assign group_bits = in[gi*GROUP_SIZE +: GROUP_SIZE];

            assign partial_and[gi] = &group_bits;
            assign partial_or[gi]  = |group_bits;
            assign partial_xor[gi] = ^group_bits;
        end
    endgenerate

    // Next, define a function to reduce an arbitrary width vector using AND, OR, XOR
    // This will be used to iteratively reduce the partial results arrays to single bits.

    // A recursive reduction function for AND
    function automatic bit reduce_and;
        input [NUM_GROUPS-1:0] vec;
        integer width;
        integer half;
        reg [NUM_GROUPS-1:0] left, right;
        begin
            width = $bits(vec);
            if (width == 1) begin
                reduce_and = vec[0];
            end else begin
                half = width / 2;
                left  = vec[half-1:0];
                right = vec[width-1:half];
                reduce_and = reduce_and(left) & reduce_and(right);
            end
        end
    endfunction

    // Similarly for OR
    function automatic bit reduce_or;
        input [NUM_GROUPS-1:0] vec;
        integer width;
        integer half;
        reg [NUM_GROUPS-1:0] left, right;
        begin
            width = $bits(vec);
            if (width == 1) begin
                reduce_or = vec[0];
            end else begin
                half = width / 2;
                left  = vec[half-1:0];
                right = vec[width-1:half];
                reduce_or = reduce_or(left) | reduce_or(right);
            end
        end
    endfunction

    // And for XOR
    function automatic bit reduce_xor;
        input [NUM_GROUPS-1:0] vec;
        integer width;
        integer half;
        reg [NUM_GROUPS-1:0] left, right;
        begin
            width = $bits(vec);
            if (width == 1) begin
                reduce_xor = vec[0];
            end else begin
                half = width / 2;
                left  = vec[half-1:0];
                right = vec[width-1:half];
                reduce_xor = reduce_xor(left) ^ reduce_xor(right);
            end
        end
    endfunction

    // Use the recursive functions to get final results from partial arrays
    assign out_and = reduce_and(partial_and);
    assign out_or  = reduce_or(partial_or);
    assign out_xor = reduce_xor(partial_xor);

endmodule