module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

// Level 0: input bits
wire [99:0] and_level0 = in;
wire [99:0] or_level0  = in;
wire [99:0] xor_level0 = in;

// Function to reduce an array of bits with the given operator
// Because Verilog does not support recursive functions for this,
// implement iterative balanced reduction manually in a generate block.

// Maximum number of levels needed: ceil(log2(100)) = 7

// Intermediate wires for AND reduction levels
wire [63:0] and_level1;
wire [31:0] and_level2;
wire [15:0] and_level3;
wire [7:0]  and_level4;
wire [3:0]  and_level5;
wire [1:0]  and_level6;
wire        and_level7;

// AND Level 1: pairwise AND of level0, with zeros padded beyond bit 99 (treated as 1 for AND)
genvar i;
generate
    for (i = 0; i < 64; i = i + 1) begin : AND_L1
        if (i*2+1 < 100)
            assign and_level1[i] = and_level0[i*2] & and_level0[i*2+1];
        else if (i*2 < 100)
            assign and_level1[i] = and_level0[i*2]; // single leftover bit
        else
            assign and_level1[i] = 1'b1; // AND identity
    end
endgenerate

// AND Level 2
generate
    for (i = 0; i < 32; i = i + 1) begin : AND_L2
        assign and_level2[i] = and_level1[i*2] & and_level1[i*2+1];
    end
endgenerate

// AND Level 3
generate
    for (i = 0; i < 16; i = i + 1) begin : AND_L3
        assign and_level3[i] = and_level2[i*2] & and_level2[i*2+1];
    end
endgenerate

// AND Level 4
generate
    for (i = 0; i < 8; i = i + 1) begin : AND_L4
        assign and_level4[i] = and_level3[i*2] & and_level3[i*2+1];
    end
endgenerate

// AND Level 5
generate
    for (i = 0; i < 4; i = i + 1) begin : AND_L5
        assign and_level5[i] = and_level4[i*2] & and_level4[i*2+1];
    end
endgenerate

// AND Level 6
generate
    for (i = 0; i < 2; i = i + 1) begin : AND_L6
        assign and_level6[i] = and_level5[i*2] & and_level5[i*2+1];
    end
endgenerate

// AND Level 7 (final)
assign and_level7 = and_level6[0] & and_level6[1];

// Similarly for OR reduction:

wire [63:0] or_level1;
wire [31:0] or_level2;
wire [15:0] or_level3;
wire [7:0]  or_level4;
wire [3:0]  or_level5;
wire [1:0]  or_level6;
wire        or_level7;

generate
    for (i = 0; i < 64; i = i + 1) begin : OR_L1
        if (i*2+1 < 100)
            assign or_level1[i] = or_level0[i*2] | or_level0[i*2+1];
        else if (i*2 < 100)
            assign or_level1[i] = or_level0[i*2]; // leftover
        else
            assign or_level1[i] = 1'b0; // OR identity
    end
endgenerate

generate
    for (i = 0; i < 32; i = i + 1) begin : OR_L2
        assign or_level2[i] = or_level1[i*2] | or_level1[i*2+1];
    end
endgenerate

generate
    for (i = 0; i < 16; i = i + 1) begin : OR_L3
        assign or_level3[i] = or_level2[i*2] | or_level2[i*2+1];
    end
endgenerate

generate
    for (i = 0; i < 8; i = i + 1) begin : OR_L4
        assign or_level4[i] = or_level3[i*2] | or_level3[i*2+1];
    end
endgenerate

generate
    for (i = 0; i < 4; i = i + 1) begin : OR_L5
        assign or_level5[i] = or_level4[i*2] | or_level4[i*2+1];
    end
endgenerate

generate
    for (i = 0; i < 2; i = i + 1) begin : OR_L6
        assign or_level6[i] = or_level5[i*2] | or_level5[i*2+1];
    end
endgenerate

assign or_level7 = or_level6[0] | or_level6[1];

// Similarly for XOR reduction:

wire [63:0] xor_level1;
wire [31:0] xor_level2;
wire [15:0] xor_level3;
wire [7:0]  xor_level4;
wire [3:0]  xor_level5;
wire [1:0]  xor_level6;
wire        xor_level7;

generate
    for (i = 0; i < 64; i = i + 1) begin : XOR_L1
        if (i*2+1 < 100)
            assign xor_level1[i] = xor_level0[i*2] ^ xor_level0[i*2+1];
        else if (i*2 < 100)
            assign xor_level1[i] = xor_level0[i*2]; // leftover
        else
            assign xor_level1[i] = 1'b0; // XOR identity
    end
endgenerate

generate
    for (i = 0; i < 32; i = i + 1) begin : XOR_L2
        assign xor_level2[i] = xor_level1[i*2] ^ xor_level1[i*2+1];
    end
endgenerate

generate
    for (i = 0; i < 16; i = i + 1) begin : XOR_L3
        assign xor_level3[i] = xor_level2[i*2] ^ xor_level2[i*2+1];
    end
endgenerate

generate
    for (i = 0; i < 8; i = i + 1) begin : XOR_L4
        assign xor_level4[i] = xor_level3[i*2] ^ xor_level3[i*2+1];
    end
endgenerate

generate
    for (i = 0; i < 4; i = i + 1) begin : XOR_L5
        assign xor_level5[i] = xor_level4[i*2] ^ xor_level4[i*2+1];
    end
endgenerate

generate
    for (i = 0; i < 2; i = i + 1) begin : XOR_L6
        assign xor_level6[i] = xor_level5[i*2] ^ xor_level5[i*2+1];
    end
endgenerate

assign xor_level7 = xor_level6[0] ^ xor_level6[1];

// Final outputs
assign out_and = and_level7;
assign out_or  = or_level7;
assign out_xor = xor_level7;

endmodule