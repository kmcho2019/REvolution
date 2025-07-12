module popcount #(parameter WIDTH = 255) (
    input  wire [WIDTH-1:0] in,
    output wire [$clog2(WIDTH+1)-1:0] out
);
    // Calculate number of levels for the adder tree
    localparam LEVELS = $clog2(WIDTH);

    // Intermediate wire arrays for sums at each level
    // At level 0, partial sums are bits themselves zero-extended to 1 bit
    // For each next level, sum adjacent pairs from previous level
    // We define wires for each level sized accordingly

    // Define a function to calculate width at each tree level
    function integer level_width(input integer level);
        integer lw;
        begin
            lw = (WIDTH + (1 << level) - 1) >> level; // ceil division by 2^level
            level_width = lw;
        end
    endfunction

    // Declare the sum vectors for each level as arrays of appropriate bit width
    // The maximum width of partial sums grows by 1 bit per level (log base 2)
    // We create a packed array for each level: each element is a vector of partial sum bits

    // Using a generate loop to build the adder tree
    // Because Verilog does not support multi-dimensional packed arrays well,
    // we use an array of wires sized for the maximum needed bitwidth per partial sum at each level.

    // Level 0: partial sums are 1-bit slices of the input zero-extended to 1 bit (i.e. bits)
    wire [0:level_width(0)-1] [0:0] sums_level0; // array of 1-bit sums
    genvar i;
    generate
        for (i = 0; i < level_width(0); i = i + 1) begin : level0_assign
            assign sums_level0[i] = (i < WIDTH) ? in[i] : 1'b0;
        end
    endgenerate

    // Now generate each higher level sums by adding pairs from previous level
    // sums_levelN[i] = sums_levelN-1[2*i] + sums_levelN-1[2*i+1]
    // Each partial sum width at level n is n+1 bits to hold max sum of 2^(n+1) -1
    // For bit vectors, index as sums_levelN[i] : vector of (n+1) bits

    // Create arrays for all levels
    // Using a generate-for to define wires and assignments for each level
    // We'll declare wires for each level separately

    // Because SystemVerilog-style multi-dimensional arrays are cleaner,
    // but we stay in Verilog, declare wires per level with vector packed as:
    // wire [width_per_sum-1:0] sums_levelN [0:level_width(N)-1]

    // Declare wires for all levels except level 0 (already declared)
    // We'll store them in a hierarchical generate block

    // Declare sums_level arrays for each level
    // sums_level0 is 1 bit wide; sums_level1 is 2 bits; sums_level2 is 3 bits, etc.

    // Declare sums_level arrays as multi-dimensional wire vectors with indexing
    // For simplicity, we declare as unpacked arrays of packed vectors

    // Define macros for maximum level index
    localparam MAX_LEVEL = LEVELS;

    // Level widths and partial sum bit widths are:
    // level n width = ceil(WIDTH / 2^n)
    // bit width per sum = n+1

    // Generate all sums arrays (except level 0 which is done)
    genvar lvl, idx;
    // Declare sums for levels 1..MAX_LEVEL
    // Using a generate block to declare wires
    // We can't declare arrays in generate block alone, so declare arrays outside

    // Declare sums arrays as wires
    // For simplicity, declare them as arrays of vectors:
    // sums_levelN [idx] is a vector [N:0]

    // Sum widths for levels
    // Use localparams for each level width and sum bit width
    // Since parameter WIDTH is 255 fixed, unroll them for given N:

    // Instead, declare arrays for all levels:
    // For synthesis and readability, use vectors of:
    // sums_level1: width = level_width(1), bitwidth = 2
    // sums_level2: width = level_width(2), bitwidth = 3, etc.

    // We can store in a generate block combining declaration and assignment
    // Use arrays of wires indexed by sum index.

    // Using a function to get sum bitwidth:
    function integer sum_bitwidth(input integer level);
        begin
            sum_bitwidth = level + 1;
        end
    endfunction

    // Declare all intermediate sums wires
    // Use a 2D vector declared as:
    // wire [sum_bitwidth(lvl)-1:0] sums_levelN [0:level_width(lvl)-1];

    // Declare them outside generate loop
    // So the full declaration:
    // For LEVELS up to 8 (since 255 bits), declare:

    wire [1:0] sums_level1 [0:level_width(1)-1];
    wire [2:0] sums_level2 [0:level_width(2)-1];
    wire [3:0] sums_level3 [0:level_width(3)-1];
    wire [4:0] sums_level4 [0:level_width(4)-1];
    wire [5:0] sums_level5 [0:level_width(5)-1];
    wire [6:0] sums_level6 [0:level_width(6)-1];
    wire [7:0] sums_level7 [0:level_width(7)-1];
    wire [8:0] sums_level8 [0:level_width(8)-1];

    // Level 0 sums already declared as 1-bit wires array
    wire sums_level0 [0:level_width(0)-1]; // single bit sums

    // Assign sums_level0 from input bits again here:
    generate
        for (i = 0; i < level_width(0); i = i +1) begin : level0_loop
            assign sums_level0[i] = (i < WIDTH) ? in[i] : 1'b0;
        end
    endgenerate

    // Assign sums_level1 from sums_level0 pairs (sum 2 bits)
    generate
        for (i = 0; i < level_width(1); i = i +1) begin : level1_loop
            assign sums_level1[i] = sums_level0[2*i] + ((2*i+1 < level_width(0)) ? sums_level0[2*i+1] : 1'b0);
        end
    endgenerate

    // Similarly assign sums_levelN from sums_levelN-1 pairs
    generate
        for (lvl = 2; lvl <= MAX_LEVEL; lvl = lvl + 1) begin : levels_loop
            for (idx = 0; idx < level_width(lvl); idx = idx + 1) begin : idx_loop
                // Get input operands from previous level sums arrays
                // We cannot index variable names directly, so use generate-if chains
                // Instead, write a function that returns value of sums at previous level for given idx, lvl

                // But Verilog generate doesn't allow functions accessing generate variables at runtime,
                // So we unroll manually for each level or do a chained generate.

                // So implement the assignments explicitly per level:

                // So break the generate loop and manually instantiate for each level after 2

            end
        end
    endgenerate

    // Manual assignments for levels 2 to 8 (max levels for 255 bits)
    // sums_level2 from sums_level1
    generate
        for (i=0; i<level_width(2); i=i+1) begin : level2_loop
            assign sums_level2[i] = sums_level1[2*i] + ((2*i+1 < level_width(1)) ? sums_level1[2*i+1] : 0);
        end
    endgenerate

    // sums_level3 from sums_level2
    generate
        for (i=0; i<level_width(3); i=i+1) begin : level3_loop
            assign sums_level3[i] = sums_level2[2*i] + ((2*i+1 < level_width(2)) ? sums_level2[2*i+1] : 0);
        end
    endgenerate

    // sums_level4 from sums_level3
    generate
        for (i=0; i<level_width(4); i=i+1) begin : level4_loop
            assign sums_level4[i] = sums_level3[2*i] + ((2*i+1 < level_width(3)) ? sums_level3[2*i+1] : 0);
        end
    endgenerate

    // sums_level5 from sums_level4
    generate
        for (i=0; i<level_width(5); i=i+1) begin : level5_loop
            assign sums_level5[i] = sums_level4[2*i] + ((2*i+1 < level_width(4)) ? sums_level4[2*i+1] : 0);
        end
    endgenerate

    // sums_level6 from sums_level5
    generate
        for (i=0; i<level_width(6); i=i+1) begin : level6_loop
            assign sums_level6[i] = sums_level5[2*i] + ((2*i+1 < level_width(5)) ? sums_level5[2*i+1] : 0);
        end
    endgenerate

    // sums_level7 from sums_level6
    generate
        for (i=0; i<level_width(7); i=i+1) begin : level7_loop
            assign sums_level7[i] = sums_level6[2*i] + ((2*i+1 < level_width(6)) ? sums_level6[2*i+1] : 0);
        end
    endgenerate

    // sums_level8 from sums_level7 (optional, may be needed for WIDTH=255)
    generate
        for (i=0; i<level_width(8); i=i+1) begin : level8_loop
            assign sums_level8[i] = sums_level7[2*i] + ((2*i+1 < level_width(7)) ? sums_level7[2*i+1] : 0);
        end
    endgenerate

    // Finally, output is the single sum at level MAX_LEVEL (which should be 1 element)
    // For 255 bits, MAX_LEVEL=8 and level_width(8) is 1 (since ceil(255/256)=1)
    // sums_level8[0] is output with bitwidth 9 bits

    // But output width is $clog2(WIDTH+1) bits = 8 bits for 255 bits?  Actually 8 bits enough to count max 255 (0..255)
    // $clog2(256) = 8, so output is 8 bits

    // The sums_level8 width is 9 bits, so truncate or assign lower bits properly

    // Assign output with bits clipped to output width
    assign out = sums_level8[0][$clog2(WIDTH+1)-1:0];

endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0]  out
);
    popcount #(.WIDTH(255)) u_popcount (
        .in(in),
        .out(out)
    );
endmodule