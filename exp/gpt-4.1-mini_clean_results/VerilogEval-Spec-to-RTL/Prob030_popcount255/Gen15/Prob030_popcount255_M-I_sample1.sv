module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Constants
    localparam CHUNKS = 32; // Number of 8-bit chunks (ceil(255/8) = 32)
    localparam LAST_CHUNK_BITS = 255 - (CHUNKS-1)*8; // = 255 - 31*8 = 255 - 248 = 7 bits in last chunk

    // Wires to hold partial popcounts for each 8-bit chunk
    wire [3:0] partial_counts [CHUNKS-1:0];

    genvar idx;
    generate
        for (idx = 0; idx < CHUNKS; idx = idx + 1) begin : popcounts_gen
            // Extract chunk bits, zero-pad last chunk if needed
            wire [7:0] chunk_in;
            if (idx < CHUNKS-1) begin
                assign chunk_in = in[8*idx +: 8];
            end else begin
                // Last chunk is only LAST_CHUNK_BITS bits, zero-pad MSBs
                assign chunk_in = { {(8-LAST_CHUNK_BITS){1'b0}}, in[254 -: LAST_CHUNK_BITS] };
                // Note: in[254 -: LAST_CHUNK_BITS] extracts from MSB downward for last chunk
            end

            popcount8 u_popcount8 (
                .in(chunk_in),
                .out(partial_counts[idx])
            );
        end
    endgenerate

    // Now sum all partial_counts[0..31] (4 bits each) in a balanced adder tree
    // Partial sums max = 255, so 8 bits output is enough.

    // Stage 1: sum pairs of partial_counts to get 16 sums (5 bits each max)
    wire [4:0] sum_stage1 [15:0];
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : stage1
            assign sum_stage1[idx] = partial_counts[2*idx] + partial_counts[2*idx+1];
        end
    endgenerate

    // Stage 2: sum pairs of stage1 outputs to get 8 sums (6 bits max)
    wire [5:0] sum_stage2 [7:0];
    generate
        for (idx = 0; idx < 8; idx = idx + 1) begin : stage2
            assign sum_stage2[idx] = sum_stage1[2*idx] + sum_stage1[2*idx+1];
        end
    endgenerate

    // Stage 3: sum pairs of stage2 outputs to get 4 sums (7 bits max)
    wire [6:0] sum_stage3 [3:0];
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : stage3
            assign sum_stage3[idx] = sum_stage2[2*idx] + sum_stage2[2*idx+1];
        end
    endgenerate

    // Stage 4: sum pairs of stage3 outputs to get 2 sums (8 bits max)
    wire [7:0] sum_stage4 [1:0];
    generate
        for (idx = 0; idx < 2; idx = idx + 1) begin : stage4
            assign sum_stage4[idx] = sum_stage3[2*idx] + sum_stage3[2*idx+1];
        end
    endgenerate

    // Final stage: sum two 8-bit sums to get final 8-bit output (max 255)
    assign out = sum_stage4[0] + sum_stage4[1];
endmodule