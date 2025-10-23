module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Parameters for grouping
    localparam GROUP_SIZE = 4;
    localparam NUM_GROUPS = (100 + GROUP_SIZE - 1) / GROUP_SIZE; // 25 groups to cover 100 bits

    // First-level partial reductions: reduction on 4-bit groups (last group may have less than 4 bits)
    // Use reduction operators on slices, padding last group if needed
    wire [NUM_GROUPS-1:0] and_lvl1;
    wire [NUM_GROUPS-1:0] or_lvl1;
    wire [NUM_GROUPS-1:0] xor_lvl1;

    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : level1_reduce
            // Compute start and width for each group
            localparam integer start_idx = i * GROUP_SIZE;
            localparam integer width = (start_idx + GROUP_SIZE <= 100) ? GROUP_SIZE : (100 - start_idx);

            // Extract slice, pad with zeros if less than GROUP_SIZE bits
            wire [GROUP_SIZE-1:0] slice = { {(GROUP_SIZE - width){1'b0}}, in[start_idx +: width] };

            // Reduction on slice
            assign and_lvl1[i] = &slice;
            assign or_lvl1[i]  = |slice;
            assign xor_lvl1[i] = ^slice;
        end
    endgenerate

    // Second-level reduction: reduce and_lvl1, or_lvl1, xor_lvl1 from 25 to 1 output each
    // Balanced binary tree with padding neutral elements for XOR/AND/OR at odd group counts

    // Function for neutral padding per op type:
    // AND neutral: 1, OR neutral: 0, XOR neutral: 0

    // We implement reduction by successive pairing until one output remains.
    // Store intermediate results in regs/wires per level.

    // Maximum tree depth = ceil(log2(NUM_GROUPS)) = 5
    // We'll implement iterative levels until size 1

    // Declare arrays for each level
    // Max nodes per level: NUM_GROUPS <= 32, so define array size accordingly

    // Level arrays for each step, max size 32
    // level_sizes[i] = number of nodes at level i
    // level 0 size = NUM_GROUPS (25)
    // level n+1 size = ceil(level_sizes[n] / 2)

    // We'll implement a recursive generate to create levels

    // Intermediate wires for AND, OR, XOR levels
    // Using two-dimensional arrays is not supported in Verilog-2001, so flatten by declaring separate arrays per level

    // Calculate sizes per level
    function integer next_level_size(input integer curr_size);
        begin
            next_level_size = (curr_size + 1) >> 1; // ceil(curr_size/2)
        end
    endfunction

    // Define level sizes (max 5 levels)
    localparam integer level0_size = NUM_GROUPS;             // 25
    localparam integer level1_size = next_level_size(level0_size); // 13
    localparam integer level2_size = next_level_size(level1_size); // 7
    localparam integer level3_size = next_level_size(level2_size); // 4
    localparam integer level4_size = next_level_size(level3_size); // 2
    localparam integer level5_size = next_level_size(level4_size); // 1

    // Declare wires for each level
    wire [level0_size-1:0] and_level0 = and_lvl1;
    wire [level0_size-1:0] or_level0  = or_lvl1;
    wire [level0_size-1:0] xor_level0 = xor_lvl1;

    wire [level1_size-1:0] and_level1;
    wire [level1_size-1:0] or_level1;
    wire [level1_size-1:0] xor_level1;

    wire [level2_size-1:0] and_level2;
    wire [level2_size-1:0] or_level2;
    wire [level2_size-1:0] xor_level2;

    wire [level3_size-1:0] and_level3;
    wire [level3_size-1:0] or_level3;
    wire [level3_size-1:0] xor_level3;

    wire [level4_size-1:0] and_level4;
    wire [level4_size-1:0] or_level4;
    wire [level4_size-1:0] xor_level4;

    wire [level5_size-1:0] and_level5;
    wire [level5_size-1:0] or_level5;
    wire [level5_size-1:0] xor_level5;

    // Reduction step macro: reduce one level to next by pairing elements and padding neutral elements if needed
    // Neutral values:
    // AND padding: 1
    // OR  padding: 0
    // XOR padding: 0

    // Generate level 1 from level 0
    generate
        for (i = 0; i < level1_size; i = i + 1) begin : reduce_level1
            // Calculate indices in level 0
            localparam int idx0 = 2*i;
            localparam int idx1 = 2*i + 1;

            // AND
            if (idx1 < level0_size) begin
                assign and_level1[i] = and_level0[idx0] & and_level0[idx1];
            end else begin
                assign and_level1[i] = and_level0[idx0] & 1'b1; // pad with 1
            end

            // OR
            if (idx1 < level0_size) begin
                assign or_level1[i] = or_level0[idx0] | or_level0[idx1];
            end else begin
                assign or_level1[i] = or_level0[idx0] | 1'b0; // pad with 0
            end

            // XOR
            if (idx1 < level0_size) begin
                assign xor_level1[i] = xor_level0[idx0] ^ xor_level0[idx1];
            end else begin
                assign xor_level1[i] = xor_level0[idx0] ^ 1'b0; // pad with 0
            end
        end
    endgenerate

    // Generate level 2 from level 1
    generate
        for (i = 0; i < level2_size; i = i + 1) begin : reduce_level2
            localparam int idx0 = 2*i;
            localparam int idx1 = 2*i + 1;

            if (idx1 < level1_size) begin
                assign and_level2[i] = and_level1[idx0] & and_level1[idx1];
                assign or_level2[i]  = or_level1[idx0]  | or_level1[idx1];
                assign xor_level2[i] = xor_level1[idx0] ^ xor_level1[idx1];
            end else begin
                assign and_level2[i] = and_level1[idx0] & 1'b1;
                assign or_level2[i]  = or_level1[idx0]  | 1'b0;
                assign xor_level2[i] = xor_level1[idx0] ^ 1'b0;
            end
        end
    endgenerate

    // Generate level 3 from level 2
    generate
        for (i = 0; i < level3_size; i = i + 1) begin : reduce_level3
            localparam int idx0 = 2*i;
            localparam int idx1 = 2*i + 1;

            if (idx1 < level2_size) begin
                assign and_level3[i] = and_level2[idx0] & and_level2[idx1];
                assign or_level3[i]  = or_level2[idx0]  | or_level2[idx1];
                assign xor_level3[i] = xor_level2[idx0] ^ xor_level2[idx1];
            end else begin
                assign and_level3[i] = and_level2[idx0] & 1'b1;
                assign or_level3[i]  = or_level2[idx0]  | 1'b0;
                assign xor_level3[i] = xor_level2[idx0] ^ 1'b0;
            end
        end
    endgenerate

    // Generate level 4 from level 3
    generate
        for (i = 0; i < level4_size; i = i + 1) begin : reduce_level4
            localparam int idx0 = 2*i;
            localparam int idx1 = 2*i + 1;

            if (idx1 < level3_size) begin
                assign and_level4[i] = and_level3[idx0] & and_level3[idx1];
                assign or_level4[i]  = or_level3[idx0]  | or_level3[idx1];
                assign xor_level4[i] = xor_level3[idx0] ^ xor_level3[idx1];
            end else begin
                assign and_level4[i] = and_level3[idx0] & 1'b1;
                assign or_level4[i]  = or_level3[idx0]  | 1'b0;
                assign xor_level4[i] = xor_level3[idx0] ^ 1'b0;
            end
        end
    endgenerate

    // Generate level 5 from level 4 (final output)
    generate
        for (i = 0; i < level5_size; i = i + 1) begin : reduce_level5
            localparam int idx0 = 2*i;
            localparam int idx1 = 2*i + 1;

            if (idx1 < level4_size) begin
                assign and_level5[i] = and_level4[idx0] & and_level4[idx1];
                assign or_level5[i]  = or_level4[idx0]  | or_level4[idx1];
                assign xor_level5[i] = xor_level4[idx0] ^ xor_level4[idx1];
            end else begin
                assign and_level5[i] = and_level4[idx0] & 1'b1;
                assign or_level5[i]  = or_level4[idx0]  | 1'b0;
                assign xor_level5[i] = xor_level4[idx0] ^ 1'b0;
            end
        end
    endgenerate

    // Final outputs are the single node in level5 arrays
    assign out_and = and_level5[0];
    assign out_or  = or_level5[0];
    assign out_xor = xor_level5[0];

endmodule