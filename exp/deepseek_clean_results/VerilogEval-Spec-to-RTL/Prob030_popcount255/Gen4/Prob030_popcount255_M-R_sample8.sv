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

// Sum all partial counts
assign out = count_groups[0] + count_groups[1] + count_groups[2] + count_groups[3] +
             count_groups[4] + count_groups[5] + count_groups[6] + count_groups[7] +
             count_groups[8] + count_groups[9] + count_groups[10] + count_groups[11] +
             count_groups[12] + count_groups[13] + count_groups[14] + count_groups[15] +
             count_groups[16] + count_groups[17] + count_groups[18] + count_groups[19] +
             count_groups[20] + count_groups[21] + count_groups[22] + count_groups[23] +
             count_groups[24] + count_groups[25] + count_groups[26] + count_groups[27] +
             count_groups[28] + count_groups[29] + count_groups[30] + count_groups[31];

endmodule