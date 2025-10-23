module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// Count '1's in 32 groups (31 groups of 8 bits + 1 group of 7 bits)
// Using 5-bit counters since max count per group is 8 (needs 4 bits)
wire [4:0] count_groups [31:0];

// Count each 8-bit group (except last which is 7 bits)
genvar i;
generate
    for (i = 0; i < 31; i = i + 1) begin : GROUP_COUNTS
        assign count_groups[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                                in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
    end
    // Last group (7 bits)
    assign count_groups[31] = in[254] + in[253] + in[252] + in[251] +
                             in[250] + in[249] + in[248];
endgenerate

// Hierarchical adder tree to sum all partial counts
// First level: 16 adders
wire [5:0] sum_level1 [15:0];
generate
    for (i = 0; i < 16; i = i + 1) begin : LEVEL1
        assign sum_level1[i] = count_groups[i*2] + count_groups[i*2+1];
    end
endgenerate

// Second level: 8 adders
wire [6:0] sum_level2 [7:0];
generate
    for (i = 0; i < 8; i = i + 1) begin : LEVEL2
        assign sum_level2[i] = sum_level1[i*2] + sum_level1[i*2+1];
    end
endgenerate

// Third level: 4 adders
wire [7:0] sum_level3 [3:0];
generate
    for (i = 0; i < 4; i = i + 1) begin : LEVEL3
        assign sum_level3[i] = sum_level2[i*2] + sum_level2[i*2+1];
    end
endgenerate

// Fourth level: 2 adders
wire [7:0] sum_level4 [1:0];
assign sum_level4[0] = sum_level3[0] + sum_level3[1];
assign sum_level4[1] = sum_level3[2] + sum_level3[3];

// Final sum
assign out = sum_level4[0] + sum_level4[1];

endmodule