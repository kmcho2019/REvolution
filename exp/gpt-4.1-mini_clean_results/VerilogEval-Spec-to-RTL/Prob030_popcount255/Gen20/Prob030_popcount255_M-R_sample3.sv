module popcountN #(parameter WIDTH = 1)(
    input  wire [WIDTH-1:0] in,
    output wire [$clog2(WIDTH+1)-1:0] out
);
    // Generic popcount using balanced recursive summation of bits
    // Implemented with generate and localparams
    
    localparam OUT_WIDTH = $clog2(WIDTH+1);
    
    // Internal recursive function to sum bits by pair
    // Because Verilog does not allow recursive generate, we'll do iterative summation stages
    
    // Calculate number of stages needed (log2 WIDTH rounded up)
    localparam STAGES = (WIDTH <= 1) ? 0 : $clog2(WIDTH);
    
    // Declare arrays for each stage
    // Stage 0: input bits zero extended to 1-bit widths
    wire [STAGES:0][ (1<<(STAGES)) -1 : 0 ] [OUT_WIDTH-1:0] sums;
    // sums[stage][index] = partial sums at each stage
    
    // Assign input bits zero extended for stage 0
    genvar i;
    generate
        for(i=0; i<WIDTH; i=i+1) begin : init_bits
            assign sums[0][i] = in[i];
        end
        for(i=WIDTH; i < (1<<STAGES); i=i+1) begin : pad_zeros
            assign sums[0][i] = {OUT_WIDTH{1'b0}};
        end
    endgenerate
    
    // Summation stages
    generate
        genvar stage, idx;
        for(stage=1; stage <= STAGES; stage=stage+1) begin : sum_stages
            localparam PREV_SIZE = (1 << (STAGES - stage +1));
            localparam CURR_SIZE = PREV_SIZE / 2;
            for(idx=0; idx < CURR_SIZE; idx=idx+1) begin : sum_pairs
                assign sums[stage][idx] = sums[stage-1][2*idx] + sums[stage-1][2*idx + 1];
            end
        end
    endgenerate
    
    // Final output is sums[STAGES][0], but if WIDTH==1 then sums[0][0]
    generate
        if (WIDTH == 1) begin : width_one_out
            assign out = sums[0][0];
        end else begin : width_gt_one_out
            assign out = sums[STAGES][0];
        end
    endgenerate
endmodule


module TopModule (
    input  wire [254:0] in,
    output wire [7:0] out
);
    // Partition input into 16 blocks:
    // 15 blocks of 16 bits (0..14), last block of 15 bits (15)
    localparam BLOCKS = 16;
    localparam BLOCK_SIZE = 16; // except last is 15
    
    // Partial counts array
    wire [4:0] pc16 [14:0];  // popcount16 outputs (5 bits)
    wire [4:0] pc15;         // popcount15 output (max 15 => 4 bits, but assign 5 bits for uniformity)
    
    genvar i;
    generate
        // 15 blocks of 16 bits
        for(i=0; i<15; i=i+1) begin : popcount16_blocks
            popcountN #(16) pc16_inst (
                .in(in[16*i +: 16]),
                .out(pc16[i])
            );
        end
    endgenerate
    
    // Last 15 bits block
    popcountN #(15) pc15_inst (
        .in(in[254:240]),
        .out(pc15)
    );
    
    // Collect all partial sums in an array of uniform width (5 bits)
    wire [4:0] partial_sums [15:0];
    generate
        for(i=0; i<15; i=i+1) begin : partial_sums_assign
            assign partial_sums[i] = pc16[i];
        end
    endgenerate
    assign partial_sums[15] = pc15;
    
    // The max sum is 255 (8 bits), so extend partial sums to 8 bits for addition
    wire [7:0] partial_sums_8 [15:0];
    generate
        for(i=0; i<16; i=i+1) begin : extend_to_8
            assign partial_sums_8[i] = {{3{1'b0}}, partial_sums[i]};
        end
    endgenerate
    
    // Balanced summation function for 16 inputs of 8 bits to 8 bits output
    // The sum max is 255 fits in 8 bits exactly
    // Implement as a generate-based balanced adder tree
    
    // level widths: 16 -> 8 -> 4 -> 2 -> 1
    wire [7:0] sum_level1 [7:0];
    wire [7:0] sum_level2 [3:0];
    wire [7:0] sum_level3 [1:0];
    wire [7:0] sum_level4;
    
    generate
        for(i=0; i<8; i=i+1) begin : lvl1_add
            assign sum_level1[i] = partial_sums_8[2*i] + partial_sums_8[2*i + 1];
        end
        
        for(i=0; i<4; i=i+1) begin : lvl2_add
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i + 1];
        end
        
        for(i=0; i<2; i=i+1) begin : lvl3_add
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i + 1];
        end
    endgenerate
    assign sum_level4 = sum_level3[0] + sum_level3[1];
    
    assign out = sum_level4;
endmodule