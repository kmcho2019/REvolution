module popcount5 (
    input  [4:0] in,
    output [2:0] out
);
    // Compute population count of 5 bits (0 to 5)
    // LUT-based combinational logic for popcount5
    wire [4:0] bits = in;
    wire [2:0] sum;

    assign sum =
        bits[0] + bits[1] + bits[2] + bits[3] + bits[4];
    assign out = sum;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Parameters
    localparam GROUP_SIZE = 5;
    // Number of groups: ceil(255/5) = 51; pad to 52 groups to align
    localparam NUM_GROUPS = 52;
    localparam PADDED_WIDTH = NUM_GROUPS * GROUP_SIZE; // 260 bits

    // Pad input with zeros for bits [259:255]
    wire [PADDED_WIDTH-1:0] in_padded = {5'b0, in}; 

    // Partial popcount outputs for each 5-bit group
    wire [2:0] partial_counts [0:NUM_GROUPS-1];

    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : POPCOUNT5_UNITS
            popcount5 pc5 (
                .in(in_padded[(i+1)*GROUP_SIZE-1 : i*GROUP_SIZE]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Now sum all partial_counts (52 numbers of max value 5)
    // Maximum sum is 255, needs 8 bits

    // We'll implement a balanced adder tree for these 3-bit partial counts

    // Flatten partial_counts into a vector for easier summation
    wire [2:0] partials_flat [0:NUM_GROUPS-1];
    generate
        for (i=0; i < NUM_GROUPS; i=i+1) begin
            assign partials_flat[i] = partial_counts[i];
        end
    endgenerate

    // Summation function: recursively add pairs until one sum remains
    function automatic [8:0] sum_partial_counts;
        input integer count;
        input [2:0] vals [0:count-1];
        integer idx;
        reg [8:0] sums [0:count-1];
        reg [8:0] next_sums [0:count/2];
        integer next_count, j;
        begin
            // Initialize sums with input vals zero-extended to 9 bits
            for (idx = 0; idx < count; idx = idx + 1) begin
                sums[idx] = vals[idx];
            end

            // Iterative pairwise addition until one remains
            while (count > 1) begin
                next_count = (count + 1) >> 1;
                for (j = 0; j < next_count; j = j + 1) begin
                    if ((2*j + 1) < count)
                        next_sums[j] = sums[2*j] + sums[2*j + 1];
                    else
                        next_sums[j] = sums[2*j];
                end
                // Copy next_sums back to sums
                for (j = 0; j < next_count; j = j + 1) begin
                    sums[j] = next_sums[j];
                end
                count = next_count;
            end
            sum_partial_counts = sums[0];
        end
    endfunction

    // To use the function in synthesizable code, we manually build an adder tree

    // Stage 1: add pairs of partial_counts (each 3-bit)
    localparam STAGE1_SIZE = (NUM_GROUPS + 1) / 2;
    wire [4:0] stage1_sums [0:STAGE1_SIZE-1];
    generate
        for (i = 0; i < STAGE1_SIZE; i = i + 1) begin : STAGE1_ADDS
            if ((2*i +1) < NUM_GROUPS) begin
                assign stage1_sums[i] = partials_flat[2*i] + partials_flat[2*i+1];
            end else begin
                assign stage1_sums[i] = partials_flat[2*i];
            end
        end
    endgenerate

    // Stage 2: add pairs of stage1_sums (each 5-bit max 10)
    localparam STAGE2_SIZE = (STAGE1_SIZE + 1) / 2;
    wire [6:0] stage2_sums [0:STAGE2_SIZE-1];
    generate
        for (i = 0; i < STAGE2_SIZE; i = i + 1) begin : STAGE2_ADDS
            if ((2*i +1) < STAGE1_SIZE) begin
                assign stage2_sums[i] = stage1_sums[2*i] + stage1_sums[2*i+1];
            end else begin
                assign stage2_sums[i] = stage1_sums[2*i];
            end
        end
    endgenerate

    // Stage 3: add pairs of stage2_sums (each 7-bit max ~20)
    localparam STAGE3_SIZE = (STAGE2_SIZE + 1) / 2;
    wire [8:0] stage3_sums [0:STAGE3_SIZE-1];
    generate
        for (i = 0; i < STAGE3_SIZE; i = i + 1) begin : STAGE3_ADDS
            if ((2*i +1) < STAGE2_SIZE) begin
                assign stage3_sums[i] = stage2_sums[2*i] + stage2_sums[2*i+1];
            end else begin
                assign stage3_sums[i] = stage2_sums[2*i];
            end
        end
    endgenerate

    // Stage 4: Add remaining stage3 sums if needed
    wire [8:0] final_sum;
    generate
        if (STAGE3_SIZE == 1) begin
            assign final_sum = stage3_sums[0];
        end else if (STAGE3_SIZE == 2) begin
            assign final_sum = stage3_sums[0] + stage3_sums[1];
        end else begin
            // For generality, add manually if more than 2, but here it's unlikely
            wire [8:0] temp_sum0 = stage3_sums[0] + stage3_sums[1];
            assign final_sum = (STAGE3_SIZE > 2) ? temp_sum0 + stage3_sums[2] : temp_sum0;
        end
    endgenerate

    // Output is the lower 8 bits of the sum (max count 255)
    assign out = final_sum[7:0];

endmodule