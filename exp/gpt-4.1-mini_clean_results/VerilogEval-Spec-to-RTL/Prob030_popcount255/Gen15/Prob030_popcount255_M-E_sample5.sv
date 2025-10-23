module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fit in 4 bits
);
    // Balanced adder tree for 8 bits
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

module popcount7 (
    input  [6:0] in,
    output [3:0] out // max 7 ones fit in 3 bits but 4 bits output for consistency
);
    // Balanced adder tree for 7 bits
    // Level 1: sum pairs (3 pairs + 1 single)
    wire [1:0] sum_l1 [2:0];
    assign sum_l1[0] = in[0] + in[1];
    assign sum_l1[1] = in[2] + in[3];
    assign sum_l1[2] = in[4] + in[5];
    wire single_bit = in[6];

    // Level 2: sum pairs of sums
    wire [2:0] sum_l2;
    assign sum_l2 = sum_l1[0] + sum_l1[1] + sum_l1[2] + single_bit;

    assign out = sum_l2; // fits in 4 bits safely
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition input into 32 groups of 8 bits and 1 group of 7 bits
    localparam N_GROUPS_8 = 32;
    localparam WIDTH_8 = 8;

    wire [3:0] pc8 [N_GROUPS_8-1:0];
    wire [3:0] pc7;

    genvar gi;
    generate
        for (gi = 0; gi < N_GROUPS_8; gi = gi + 1) begin : pc8_blocks
            popcount8 pc8_inst (
                .in(in[gi*8 +: 8]),
                .out(pc8[gi])
            );
        end
    endgenerate

    popcount7 pc7_inst (
        .in(in[255-7:255-7+7-1]), // bits 256-8=248 to 254: Actually 255 bits means highest index is 254, so bits 256-8=248 to 254 are bits [254:248]
        .out(pc7)
    );

    // Now sum all 33 partial results: 32 of 4 bits + 1 of 4 bits
    // Use balanced adder tree over 33 4-bit values to get 8-bit output

    // First create array of 33 values (4 bits each)
    wire [3:0] pc_all [32:0];
    assign pc_all[32] = pc7;
    generate
        for (gi = 0; gi < N_GROUPS_8; gi = gi + 1) begin
            assign pc_all[gi] = pc8[gi];
        end
    endgenerate

    // Adder tree implementation:
    // At each stage combine pairs of elements into sums with one extra bit to avoid overflow
    // Continue until single sum remains

    // We need a recursive generate block to perform the adder tree
    // Implement as a parameterized function to sum arrays of variable size

    // Maximum width for partial sums:
    // Each partial count max 8, so 4 bits
    // Summing 33 x 8 = 264 max, fits in 9 bits (but we use 8 bits output, assume output bits 7:0)
    // Use 8 bits output as requested

    // We will keep track of width growing at each level (since sum width = previous width + 1)
    // Start width is 4 bits per partial count

    // Create a function to perform the balanced summation

    // To handle Verilog limitations, we do the tree manually using arrays and loops

    // Declare stage arrays dynamically
    // The number of elements reduces by roughly half each stage
    // We will define a parameterizable generate block outside procedural code

    // We store sums in reg arrays and assign combinationally

    // Create max depth as ceil(log2(33))=6

    localparam integer MAX_STAGE = 6;

    // Stage 0 input widths are 4 bits
    wire [4 + MAX_STAGE -1:0] stage [0:MAX_STAGE][0:32]; // stage, index; width grows by 1 bit per stage: 4 + stage

    // Assign stage 0 input
    genvar idx;
    generate
        for (idx = 0; idx < 33; idx = idx + 1) begin : stage0_init
            assign stage[0][idx] = { {(MAX_STAGE){1'b0}}, pc_all[idx] }; 
            // pad upper bits with zero for uniform width: total width 4+MAX_STAGE bits
        end
        for (idx = 33; idx < 64; idx = idx +1) begin : stage0_zero // fill unused entries with zero
            assign stage[0][idx] = { (4+MAX_STAGE){1'b0} };
        end
    endgenerate

    // For stages 1 to MAX_STAGE, sum pairs of stage[i-1], width increases by 1 bit per stage
    genvar stage_i, pair_i;
    generate
        for (stage_i = 1; stage_i <= MAX_STAGE; stage_i = stage_i + 1) begin : stages
            localparam integer prev_width = 4 + (MAX_STAGE - stage_i +1);
            localparam integer width = 4 + (MAX_STAGE - stage_i);
            localparam integer num_elems_prev = (stage_i == 1) ? 33 : ( (33 + (1 << (stage_i-1)) - 1) >> (stage_i - 1) );
            localparam integer num_elems = (num_elems_prev + 1) >> 1;

            for (pair_i = 0; pair_i < num_elems; pair_i = pair_i + 1) begin : pairs
                wire [prev_width-1:0] a = stage[stage_i-1][pair_i*2];
                wire [prev_width-1:0] b = (pair_i*2+1 < num_elems_prev) ? stage[stage_i-1][pair_i*2+1] : {prev_width{1'b0}};
                assign stage[stage_i][pair_i] = a + b;
            end

            // Zero out unused entries in the stage array for safety
            for (pair_i = num_elems; pair_i < 64; pair_i = pair_i + 1) begin : zero_unused
                assign stage[stage_i][pair_i] = {width{1'b0}};
            end
        end
    endgenerate

    // Final sum is stage MAX_STAGE with 1 element, width = 4 + (MAX_STAGE - MAX_STAGE) = 4 bits +0 = 4 bits? Actually we added one bit per stage downward, so recalc carefully:
    // Actually stage 0 has width = 4 + MAX_STAGE bits, next stage reduce 1 bit? Actually previous logic zero-padded to fixed width 4 + MAX_STAGE bits, but addition of two numbers each width W results in W+1 bit.
    // To simplify, we forced max width on stage 0 and ignore that width grows? Let's just take the final output bits directly as stage[MAX_STAGE][0], truncate or zero extend to 8 bits

    // Since max sum is 255, 8 bits suffice:
    wire [7:0] final_sum = stage[MAX_STAGE][0][7:0];

    assign out = final_sum;
endmodule