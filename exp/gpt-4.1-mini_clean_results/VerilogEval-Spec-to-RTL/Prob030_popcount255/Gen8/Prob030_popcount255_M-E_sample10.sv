module popcount3 (
    input  [2:0] in,
    output [1:0] out // max 3 ones => needs 2 bits
);
    // The popcount of 3 bits can be computed by logic:
    // out = in[0] + in[1] + in[2]
    // Use simple logic:
    assign out = in[0] + in[1] + in[2];
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Step 1: Divide input into 85 groups of 3 bits (85*3=255)
    wire [1:0] partial_counts [84:0]; // 85 partial counts, each 2 bits max (0..3)

    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : pc3_blocks
            popcount3 pc (
                .in(in[3*i +: 3]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Step 2: Sum the 85 partial 2-bit counts into one 8-bit output
    // Max sum = 85 * 3 = 255 fits in 8 bits

    // We'll implement a balanced adder tree to sum these 2-bit numbers:

    // Helper function: sum pairs of N-bit numbers to (N+1)-bit output

    // Because the inputs start 2 bits wide, sums grow by 1 bit each level:
    // Level 0: inputs 2 bits x 85
    // Level 1: 2 bits + 2 bits = 3 bits (max 3+3=6 < 8)
    // Level 2: 3 bits + 3 bits = 4 bits
    // Level 3: 4 bits + 4 bits = 5 bits
    // ...
    // Continue until only one sum remains.

    // Use a generate loop with an array of wires to hold each level's sums.

    // Define max number of elements at each level, to handle odd elements by passing last through.

    // Since 85 is not power of two, at each level odd elements will carry forward.

    // We'll implement a recursive function in generate loop fashion:

    // Maximum levels needed ~7 (since 2^7=128 >85).

    // Define arrays for each level:
    // Each element width = 2 + level bits

    localparam LEVELS = 7;

    // Create arrays for each level
    wire [LEVELS+1:0] sums_widths [LEVELS:0]; // Width of sums at each level, starts from 2 bits at level0

    // We'll define the width per level at run-time in code below (for clarity)

    // Store sums in reg arrays to accommodate variable widths in generate blocks.

    // Instead of using a single multidimensional array of varying widths (which is not supported),
    // We declare an array of wires for each level separately.

    // Level 0: 85 inputs, width 2
    wire [1:0] level0 [84:0];
    // Assign from partial_counts
    generate
        for (i=0; i<85; i=i+1) begin
            assign level0[i] = partial_counts[i];
        end
    endgenerate

    // Level 1: ceil(85/2)=43 sums, width 3 bits (since max sum per element grows by 1 bit)
    wire [2:0] level1 [42:0];

    generate
        for (i=0; i<42; i=i+1) begin
            assign level1[i] = level0[2*i] + level0[2*i+1];
        end
        // If odd number of elements at level0, pass last through zero-extended
        assign level1[42] = {1'b0, level0[84]};
    endgenerate

    // Level 2: ceil(43/2)=22 sums, width 4 bits
    wire [3:0] level2 [21:0];

    generate
        for (i=0; i<21; i=i+1) begin
            assign level2[i] = level1[2*i] + level1[2*i+1];
        end
        assign level2[21] = {1'b0, level1[42]};
    endgenerate

    // Level 3: ceil(22/2)=11 sums, width 5 bits
    wire [4:0] level3 [10:0];

    generate
        for (i=0; i<10; i=i+1) begin
            assign level3[i] = level2[2*i] + level2[2*i+1];
        end
        assign level3[10] = {1'b0, level2[21]};
    endgenerate

    // Level 4: ceil(11/2)=6 sums, width 6 bits
    wire [5:0] level4 [5:0];

    generate
        for (i=0; i<5; i=i+1) begin
            assign level4[i] = level3[2*i] + level3[2*i+1];
        end
        assign level4[5] = {1'b0, level3[10]};
    endgenerate

    // Level 5: ceil(6/2)=3 sums, width 7 bits
    wire [6:0] level5 [2:0];

    generate
        for (i=0; i<2; i=i+1) begin
            assign level5[i] = level4[2*i] + level4[2*i+1];
        end
        assign level5[2] = level4[5];
    endgenerate

    // Level 6: ceil(3/2)=2 sums, width 8 bits
    wire [7:0] level6 [1:0];

    assign level6[0] = level5[0] + level5[1];
    assign level6[1] = {1'b0, level5[2]}; // zero extend level5[2] to 8 bits

    // Level 7: final sum, 8 bits
    assign out = level6[0] + level6[1];

endmodule