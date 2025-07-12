module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Maximum number of levels needed ~log2(100) + 1 = 8
    // We'll define arrays for each level.
    // Level 0 inputs are in[99:0]

    // To hold intermediate wires, dimension largest needed size: 100 at level 0
    // At each next level, size roughly half previous (ceil for odd counts)
    
    // Declare wires for all levels
    // To keep sizes manageable, declare max possible level size = 100, but only relevant parts used
    
    // Level 0 arrays are inputs directly:
    wire [99:0] and_level [0:8];
    wire [99:0] or_level  [0:8];
    wire [99:0] xor_level [0:8];

    genvar i, lvl;

    // Assign level 0 from inputs directly
    generate
        for (i = 0; i < 100; i = i + 1) begin : level0_assign
            assign and_level[0][i] = in[i];
            assign or_level[0][i]  = in[i];
            assign xor_level[0][i] = in[i];
        end
    endgenerate

    // Reduce each level into next level by pairs (2-input gate)
    // Size of level n+1 = ceil(size_of_level_n / 2)

    // Compute sizes dynamically with parameters (localparam arrays not allowed in Verilog-2001,
    // so sizes computed per iteration below)

    // We'll build combinational logic for each level until size 1 reached

    // We track current level size with variable, but Verilog generate is static,
    // so precompute sizes:

    localparam int LEVEL0_SIZE = 100;
    localparam int LEVEL1_SIZE = (LEVEL0_SIZE+1)/2; // 50
    localparam int LEVEL2_SIZE = (LEVEL1_SIZE+1)/2; // 25
    localparam int LEVEL3_SIZE = (LEVEL2_SIZE+1)/2; // 13
    localparam int LEVEL4_SIZE = (LEVEL3_SIZE+1)/2; // 7
    localparam int LEVEL5_SIZE = (LEVEL4_SIZE+1)/2; // 4
    localparam int LEVEL6_SIZE = (LEVEL5_SIZE+1)/2; // 2
    localparam int LEVEL7_SIZE = (LEVEL6_SIZE+1)/2; // 1

    // Level 1 reduction
    generate
        for (i = 0; i < LEVEL1_SIZE; i = i + 1) begin : level1_reduce
            if (2*i+1 < LEVEL0_SIZE) begin
                assign and_level[1][i] = and_level[0][2*i] & and_level[0][2*i+1];
                assign or_level[1][i]  = or_level[0][2*i] | or_level[0][2*i+1];
                assign xor_level[1][i] = xor_level[0][2*i] ^ xor_level[0][2*i+1];
            end else begin
                // Odd leftover, just propagate
                assign and_level[1][i] = and_level[0][2*i];
                assign or_level[1][i]  = or_level[0][2*i];
                assign xor_level[1][i] = xor_level[0][2*i];
            end
        end
    endgenerate

    // Level 2 reduction
    generate
        for (i = 0; i < LEVEL2_SIZE; i = i + 1) begin : level2_reduce
            if (2*i+1 < LEVEL1_SIZE) begin
                assign and_level[2][i] = and_level[1][2*i] & and_level[1][2*i+1];
                assign or_level[2][i]  = or_level[1][2*i] | or_level[1][2*i+1];
                assign xor_level[2][i] = xor_level[1][2*i] ^ xor_level[1][2*i+1];
            end else begin
                assign and_level[2][i] = and_level[1][2*i];
                assign or_level[2][i]  = or_level[1][2*i];
                assign xor_level[2][i] = xor_level[1][2*i];
            end
        end
    endgenerate

    // Level 3 reduction
    generate
        for (i = 0; i < LEVEL3_SIZE; i = i + 1) begin : level3_reduce
            if (2*i+1 < LEVEL2_SIZE) begin
                assign and_level[3][i] = and_level[2][2*i] & and_level[2][2*i+1];
                assign or_level[3][i]  = or_level[2][2*i] | or_level[2][2*i+1];
                assign xor_level[3][i] = xor_level[2][2*i] ^ xor_level[2][2*i+1];
            end else begin
                assign and_level[3][i] = and_level[2][2*i];
                assign or_level[3][i]  = or_level[2][2*i];
                assign xor_level[3][i] = xor_level[2][2*i];
            end
        end
    endgenerate

    // Level 4 reduction
    generate
        for (i = 0; i < LEVEL4_SIZE; i = i + 1) begin : level4_reduce
            if (2*i+1 < LEVEL3_SIZE) begin
                assign and_level[4][i] = and_level[3][2*i] & and_level[3][2*i+1];
                assign or_level[4][i]  = or_level[3][2*i] | or_level[3][2*i+1];
                assign xor_level[4][i] = xor_level[3][2*i] ^ xor_level[3][2*i+1];
            end else begin
                assign and_level[4][i] = and_level[3][2*i];
                assign or_level[4][i]  = or_level[3][2*i];
                assign xor_level[4][i] = xor_level[3][2*i];
            end
        end
    endgenerate

    // Level 5 reduction
    generate
        for (i = 0; i < LEVEL5_SIZE; i = i + 1) begin : level5_reduce
            if (2*i+1 < LEVEL4_SIZE) begin
                assign and_level[5][i] = and_level[4][2*i] & and_level[4][2*i+1];
                assign or_level[5][i]  = or_level[4][2*i] | or_level[4][2*i+1];
                assign xor_level[5][i] = xor_level[4][2*i] ^ xor_level[4][2*i+1];
            end else begin
                assign and_level[5][i] = and_level[4][2*i];
                assign or_level[5][i]  = or_level[4][2*i];
                assign xor_level[5][i] = xor_level[4][2*i];
            end
        end
    endgenerate

    // Level 6 reduction
    generate
        for (i = 0; i < LEVEL6_SIZE; i = i + 1) begin : level6_reduce
            if (2*i+1 < LEVEL5_SIZE) begin
                assign and_level[6][i] = and_level[5][2*i] & and_level[5][2*i+1];
                assign or_level[6][i]  = or_level[5][2*i] | or_level[5][2*i+1];
                assign xor_level[6][i] = xor_level[5][2*i] ^ xor_level[5][2*i+1];
            end else begin
                assign and_level[6][i] = and_level[5][2*i];
                assign or_level[6][i]  = or_level[5][2*i];
                assign xor_level[6][i] = xor_level[5][2*i];
            end
        end
    endgenerate

    // Level 7 reduction
    generate
        for (i = 0; i < LEVEL7_SIZE; i = i + 1) begin : level7_reduce
            if (2*i+1 < LEVEL6_SIZE) begin
                assign and_level[7][i] = and_level[6][2*i] & and_level[6][2*i+1];
                assign or_level[7][i]  = or_level[6][2*i] | or_level[6][2*i+1];
                assign xor_level[7][i] = xor_level[6][2*i] ^ xor_level[6][2*i+1];
            end else begin
                assign and_level[7][i] = and_level[6][2*i];
                assign or_level[7][i]  = or_level[6][2*i];
                assign xor_level[7][i] = xor_level[6][2*i];
            end
        end
    endgenerate

    // Final output assigned from the single remaining signals at level 7 (only 1 element)
    assign out_and = and_level[7][0];
    assign out_or  = or_level[7][0];
    assign out_xor = xor_level[7][0];

endmodule