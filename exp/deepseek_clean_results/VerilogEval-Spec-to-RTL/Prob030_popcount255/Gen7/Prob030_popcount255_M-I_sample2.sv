module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// Pad input to 256 bits (32 groups of 8 bits) by adding a zero
wire [255:0] padded_in = {1'b0, in};

// Count '1's in each 8-bit group
wire [3:0] group_counts [31:0];  // 4 bits per group (max 8)

genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : GROUP_COUNTS
        assign group_counts[i] = 
            padded_in[i*8+7] + padded_in[i*8+6] + padded_in[i*8+5] + padded_in[i*8+4] +
            padded_in[i*8+3] + padded_in[i*8+2] + padded_in[i*8+1] + padded_in[i*8];
    end
endgenerate

// Balanced adder tree (5 levels)
// Level 1: 16 adders (32 -> 16)
wire [4:0] sum_l1 [15:0];
generate
    for (i = 0; i < 16; i = i + 1) begin : LEVEL1
        assign sum_l1[i] = group_counts[i*2] + group_counts[i*2+1];
    end
endgenerate

// Level 2: 8 adders (16 -> 8)
wire [5:0] sum_l2 [7:0];
generate
    for (i = 0; i < 8; i = i + 1) begin : LEVEL2
        assign sum_l2[i] = sum_l1[i*2] + sum_l1[i*2+1];
    end
endgenerate

// Level 3: 4 adders (8 -> 4)
wire [6:0] sum_l3 [3:0];
generate
    for (i = 0; i < 4; i = i + 1) begin : LEVEL3
        assign sum_l3[i] = sum_l2[i*2] + sum_l2[i*2+1];
    end
endgenerate

// Level 4: 2 adders (4 -> 2)
wire [7:0] sum_l4 [1:0];
generate
    for (i = 0; i < 2; i = i + 1) begin : LEVEL4
        assign sum_l4[i] = sum_l3[i*2] + sum_l3[i*2+1];
    end
endgenerate

// Level 5: Final adder (2 -> 1)
assign out = sum_l4[0] + sum_l4[1];

endmodule