module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// Count '1's in 32 groups (31 groups of 8 bits + 1 group of 7 bits)
wire [7:0] count_groups [31:0];

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

// Sum all partial counts using a balanced adder tree
wire [7:0] sum_stage1 [15:0];
wire [7:0] sum_stage2 [7:0];
wire [7:0] sum_stage3 [3:0];
wire [7:0] sum_stage4 [1:0];

// Stage 1: Add pairs of groups
generate
    for (i = 0; i < 16; i = i + 1) begin : STAGE1
        assign sum_stage1[i] = count_groups[2*i] + count_groups[2*i+1];
    end
endgenerate

// Stage 2: Add pairs of stage1 results
generate
    for (i = 0; i < 8; i = i + 1) begin : STAGE2
        assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1];
    end
endgenerate

// Stage 3: Add pairs of stage2 results
generate
    for (i = 0; i < 4; i = i + 1) begin : STAGE3
        assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
    end
endgenerate

// Stage 4: Add pairs of stage3 results
generate
    for (i = 0; i < 2; i = i + 1) begin : STAGE4
        assign sum_stage4[i] = sum_stage3[2*i] + sum_stage3[2*i+1];
    end
endgenerate

// Final sum
assign out = sum_stage4[0] + sum_stage4[1];

endmodule