module popcount8(
    input  [7:0] in,
    output [4:0] out
);
    // 8-bit popcount fits in 4 bits, 5 bits width for margin
    // Implementation: sum bits by splitting input into halves

    wire [3:0] half0 = in[3:0];
    wire [3:0] half1 = in[7:4];

    wire [3:0] cnt_half0;
    wire [3:0] cnt_half1;

    // sum 4 bits by simple addition
    assign cnt_half0 = half0[0] + half0[1] + half0[2] + half0[3];
    assign cnt_half1 = half1[0] + half1[1] + half1[2] + half1[3];

    assign out = cnt_half0 + cnt_half1;
endmodule

module popcount_last_chunk #(
    parameter WIDTH = 7
)(
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Popcount for last chunk if less than 8 bits (e.g. 7 bits)
    // Implemented as simple addition

    integer i;
    reg [$clog2(WIDTH+1)-1:0] sum;
    always @(*) begin
        sum = 0;
        for (i=0; i<WIDTH; i=i+1) begin
            sum = sum + in[i];
        end
    end
    assign out = sum;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Parameters
    localparam CHUNK_SIZE = 8;
    localparam NUM_CHUNKS = (255 + CHUNK_SIZE - 1) / CHUNK_SIZE; // 32 chunks
    localparam LAST_CHUNK_WIDTH = 255 - (CHUNK_SIZE * (NUM_CHUNKS - 1)); // 7 bits last chunk

    // Partial popcount outputs
    wire [4:0] partial_counts [NUM_CHUNKS-1:0]; // 5 bits width per chunk max

    genvar i;

    generate
        // For chunks 0 to NUM_CHUNKS-2 (full 8-bit chunks)
        for (i = 0; i < NUM_CHUNKS-1; i = i + 1) begin : popcount_chunks
            popcount8 pc8 (
                .in(in[i*CHUNK_SIZE +: CHUNK_SIZE]),
                .out(partial_counts[i])
            );
        end
        // Last chunk - may be less than 8 bits
        if (LAST_CHUNK_WIDTH < CHUNK_SIZE) begin : last_chunk
            popcount_last_chunk #(.WIDTH(LAST_CHUNK_WIDTH)) pc_last (
                .in(in[(NUM_CHUNKS-1)*CHUNK_SIZE +: LAST_CHUNK_WIDTH]),
                .out(partial_counts[NUM_CHUNKS-1])
            );
        end else begin : last_chunk_full
            popcount8 pc8_last (
                .in(in[(NUM_CHUNKS-1)*CHUNK_SIZE +: CHUNK_SIZE]),
                .out(partial_counts[NUM_CHUNKS-1])
            );
        end
    endgenerate

    // Now sum all partial counts (32 numbers of max 5 bits) using a balanced adder tree

    // Each partial count is 5 bits, max total sum is 255 which fits in 8 bits

    // Stage 1: sum pairs to get 16 sums of up to 6 bits (max 31+31=62)
    wire [5:0] sum_stage1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1
            assign sum_stage1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Stage 2: sum pairs to get 8 sums of up to 7 bits (max 62+62=124)
    wire [6:0] sum_stage2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2
            assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1];
        end
    endgenerate

    // Stage 3: sum pairs to get 4 sums of up to 8 bits (max 124+124=248)
    wire [7:0] sum_stage3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage3
            assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
        end
    endgenerate

    // Stage 4: sum pairs to get 2 sums of up to 9 bits (max 248+248=496, fits in 9 bits)
    wire [8:0] sum_stage4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage4
            assign sum_stage4[i] = sum_stage3[2*i] + sum_stage3[2*i+1];
        end
    endgenerate

    // Stage 5: final sum of two 9-bit values, fits in 10 bits max (496+496=992)
    wire [9:0] sum_final_wide;
    assign sum_final_wide = sum_stage4[0] + sum_stage4[1];

    // Output is 8 bits (max 255), so upper bits must be zero
    // The input is 255 bits max, so max popcount is 255, which fits in 8 bits
    // Therefore, truncate or mask upper bits
    assign out = sum_final_wide[7:0];

endmodule