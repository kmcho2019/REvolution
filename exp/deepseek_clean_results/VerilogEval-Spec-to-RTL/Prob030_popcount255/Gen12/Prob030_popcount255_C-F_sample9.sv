module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// First level: Count '1's in 32 groups (31 groups of 8 bits + 1 group of 7 bits)
wire [7:0] count_groups [0:31];

genvar i;
generate
    // Count each 8-bit group
    for (i = 0; i < 31; i = i + 1) begin : GROUP_COUNTS
        assign count_groups[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                                in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
    end
    // Last group (7 bits)
    assign count_groups[31] = in[254] + in[253] + in[252] + in[251] +
                             in[250] + in[249] + in[248];
endgenerate

// Second level: Hierarchical adder tree
wire [7:0] level1 [0:15];
wire [7:0] level2 [0:7];
wire [7:0] level3 [0:3];
wire [7:0] level4 [0:1];
wire [7:0] level5;

generate
    // Level 1: Sum pairs of groups (16 adders)
    for (i = 0; i < 16; i = i + 1) begin : ADDER_LEVEL1
        assign level1[i] = count_groups[i*2] + count_groups[i*2+1];
    end

    // Level 2: Sum pairs of level1 results (8 adders)
    for (i = 0; i < 8; i = i + 1) begin : ADDER_LEVEL2
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end

    // Level 3: Sum pairs of level2 results (4 adders)
    for (i = 0; i < 4; i = i + 1) begin : ADDER_LEVEL3
        assign level3[i] = level2[i*2] + level2[i*2+1];
    end

    // Level 4: Sum pairs of level3 results (2 adders)
    for (i = 0; i < 2; i = i + 1) begin : ADDER_LEVEL4
        assign level4[i] = level3[i*2] + level3[i*2+1];
    end

    // Final adder
    assign level5 = level4[0] + level4[1];
endgenerate

assign out = level5;

endmodule