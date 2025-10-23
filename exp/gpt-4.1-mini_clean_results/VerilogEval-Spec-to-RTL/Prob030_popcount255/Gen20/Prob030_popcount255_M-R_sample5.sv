module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);
    // Parameters for chunk size and counts
    localparam CHUNK_SIZE = 8;
    // Number of chunks (ceil(255/8) = 32)
    localparam NUM_CHUNKS = (255 + CHUNK_SIZE - 1) / CHUNK_SIZE;

    // Partial sums array: holds popcount of each chunk (max 8 bits, so max value 8)
    wire [3:0] partial_sums [0:NUM_CHUNKS-1]; // 4 bits enough to count up to 8 ones

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : chunk_popcount
            // Extract chunk bits safely
            wire [CHUNK_SIZE-1:0] chunk_bits;
            if (i < NUM_CHUNKS - 1) begin
                assign chunk_bits = in[i*CHUNK_SIZE +: CHUNK_SIZE];
            end else begin
                // Last chunk may have less than CHUNK_SIZE bits (255 % 8 = 7 bits)
                assign chunk_bits = { {CHUNK_SIZE - (255 - i*CHUNK_SIZE){1'b0}}, in[i*CHUNK_SIZE +: (255 - i*CHUNK_SIZE)] };
            end
            // Count bits in chunk by summing bits
            assign partial_sums[i] = chunk_bits[0] + chunk_bits[1] + chunk_bits[2] + chunk_bits[3] +
                                     chunk_bits[4] + chunk_bits[5] + chunk_bits[6] + chunk_bits[7];
        end
    endgenerate

    // Now reduce partial_sums array by summing pairs in stages until one value remains.
    // We'll do this iteratively with wires arrays, halving size each time.

    // We define a function to calculate needed width at each stage:
    // At stage 0: partial sums max 8 (4 bits)
    // Each sum doubles max possible count, so bit width increases by 1 at each stage.

    // Stage width calculation
    function integer stage_width(input integer prev_width);
        stage_width = prev_width + 1;
    endfunction

    // Stage 0 inputs: partial_sums (4 bits each)
    localparam integer STAGE0_WIDTH = 4;
    localparam integer STAGE1_SIZE = (NUM_CHUNKS + 1) / 2; // half rounded up
    localparam integer STAGE1_WIDTH = stage_width(STAGE0_WIDTH);

    // Wires for stage 1 sums
    wire [STAGE1_WIDTH-1:0] stage1 [0:STAGE1_SIZE-1];

    genvar j;
    generate
        for (j = 0; j < STAGE1_SIZE; j = j + 1) begin : stage1_reduce
            wire [STAGE0_WIDTH-1:0] a = partial_sums[2*j];
            wire [STAGE0_WIDTH-1:0] b = (2*j+1 < NUM_CHUNKS) ? partial_sums[2*j+1] : {STAGE0_WIDTH{1'b0}};
            assign stage1[j] = a + b;
        end
    endgenerate

    // Next stages iteratively reduce until one value remains
    // We can do this by a generate loop with arrays of wires for stages
    // Max number of stages needed = ceil(log2(NUM_CHUNKS)) = 5 (since 32 chunks)

    // We'll define arrays for stage sizes and widths
    localparam integer MAX_STAGES = 6; // enough for safety
    integer stage_sizes [0:MAX_STAGES-1];
    integer stage_widths [0:MAX_STAGES-1];
    initial begin
        stage_sizes[0] = STAGE1_SIZE;
        stage_widths[0] = STAGE1_WIDTH;
        integer s;
        for (s = 1; s < MAX_STAGES; s = s + 1) begin
            stage_sizes[s] = (stage_sizes[s-1] + 1) / 2;
            stage_widths[s] = stage_width(stage_widths[s-1]);
        end
    end

    // Because generate cannot use variables declared inside initial,
    // we unroll manually for 5 stages max (s=1..5), starting with stage1 arrays already declared

    // Stage arrays declaration:
    // stage1: already declared above

    wire [stage_widths[1]-1:0] stage2 [0:stage_sizes[1]-1];
    wire [stage_widths[2]-1:0] stage3 [0:stage_sizes[2]-1];
    wire [stage_widths[3]-1:0] stage4 [0:stage_sizes[3]-1];
    wire [stage_widths[4]-1:0] stage5 [0:stage_sizes[4]-1];
    wire [stage_widths[5]-1:0] stage6 [0:stage_sizes[5]-1];

    // Helper macro to sum pairs for each stage
    // For stage N: input array stageN, output stageN+1

    // Stage 2
    generate
        for (j = 0; j < stage_sizes[1]; j = j + 1) begin : stage2_reduce
            wire [stage_widths[0]-1:0] a = stage1[2*j];
            wire [stage_widths[0]-1:0] b = (2*j+1 < stage_sizes[0]) ? stage1[2*j+1] : {stage_widths[0]{1'b0}};
            assign stage2[j] = a + b;
        end
    endgenerate

    // Stage 3
    generate
        for (j = 0; j < stage_sizes[2]; j = j + 1) begin : stage3_reduce
            wire [stage_widths[1]-1:0] a = stage2[2*j];
            wire [stage_widths[1]-1:0] b = (2*j+1 < stage_sizes[1]) ? stage2[2*j+1] : {stage_widths[1]{1'b0}};
            assign stage3[j] = a + b;
        end
    endgenerate

    // Stage 4
    generate
        for (j = 0; j < stage_sizes[3]; j = j + 1) begin : stage4_reduce
            wire [stage_widths[2]-1:0] a = stage3[2*j];
            wire [stage_widths[2]-1:0] b = (2*j+1 < stage_sizes[2]) ? stage3[2*j+1] : {stage_widths[2]{1'b0}};
            assign stage4[j] = a + b;
        end
    endgenerate

    // Stage 5
    generate
        for (j = 0; j < stage_sizes[4]; j = j + 1) begin : stage5_reduce
            wire [stage_widths[3]-1:0] a = stage4[2*j];
            wire [stage_widths[3]-1:0] b = (2*j+1 < stage_sizes[3]) ? stage4[2*j+1] : {stage_widths[3]{1'b0}};
            assign stage5[j] = a + b;
        end
    endgenerate

    // Stage 6 (final)
    generate
        for (j = 0; j < stage_sizes[5]; j = j + 1) begin : stage6_reduce
            wire [stage_widths[4]-1:0] a = stage5[2*j];
            wire [stage_widths[4]-1:0] b = (2*j+1 < stage_sizes[4]) ? stage5[2*j+1] : {stage_widths[4]{1'b0}};
            assign stage6[j] = a + b;
        end
    endgenerate

    // After stage 6, stage_sizes[5] should be 1 for 32 chunks input.

    // Assign final output from stage6[0], truncated or padded to 8 bits.
    // stage_widths[5] will be >=8 (actually 10 bits since width grows each stage)
    assign out = stage6[0][7:0];

endmodule