module TopModule (
    input  [99:0] in,
    output reg    out_and,
    output reg    out_or,
    output reg    out_xor
);

    // Intermediate vectors for each reduction stage
    reg [99:0] and_stage [0:6]; // Enough stages to reduce 100 -> 1
    reg [99:0] or_stage  [0:6];
    reg [99:0] xor_stage [0:6];

    integer i, j, count;

    always @* begin
        // Initialize stage 0 with input values, zero-extend unused bits beyond 99
        // Though input size is exactly 100, to simplify indexing, 
        // unused bits beyond input width are set to 1 for AND and 0 for OR/XOR.

        // Initialize first stage for AND, OR, XOR
        for (i = 0; i < 100; i = i + 1) begin
            and_stage[0][i] = in[i];
            or_stage[0][i]  = in[i];
            xor_stage[0][i] = in[i];
        end
        for (i = 100; i < 128; i = i + 1) begin
            // For inputs beyond 99, AND should use 1 to not affect AND,
            // OR and XOR use 0 to not affect result.
            and_stage[0][i] = 1'b1;
            or_stage[0][i]  = 1'b0;
            xor_stage[0][i] = 1'b0;
        end

        // Perform balanced tree reduction stage by stage
        // Each next stage halves the number of elements approximately
        count = 128; // Using 128 for convenience (next power of two >= 100)
        for (j = 1; j < 8; j = j + 1) begin
            // Number of elements in this stage is half of previous (rounded up)
            integer next_count = (count + 1) >> 1;
            for (i = 0; i < next_count; i = i + 1) begin
                // Calculate indices of pair elements
                integer idx0 = i * 2;
                integer idx1 = idx0 + 1;
                // If idx1 >= count, only idx0 element is available
                if (idx1 < count) begin
                    and_stage[j][i] = and_stage[j-1][idx0] & and_stage[j-1][idx1];
                    or_stage[j][i]  = or_stage[j-1][idx0]  | or_stage[j-1][idx1];
                    xor_stage[j][i] = xor_stage[j-1][idx0] ^ xor_stage[j-1][idx1];
                end else begin
                    and_stage[j][i] = and_stage[j-1][idx0];
                    or_stage[j][i]  = or_stage[j-1][idx0];
                    xor_stage[j][i] = xor_stage[j-1][idx0];
                end
            end
            count = next_count;
        end

        // Final result at stage 7 index 0
        out_and = and_stage[7][0];
        out_or  = or_stage[7][0];
        out_xor = xor_stage[7][0];
    end

endmodule