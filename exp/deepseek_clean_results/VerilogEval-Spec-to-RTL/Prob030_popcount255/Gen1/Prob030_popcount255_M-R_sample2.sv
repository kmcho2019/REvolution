module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// Count 1s in each 8-bit segment (31 full segments + 1 partial)
wire [3:0] seg_counts [0:31];
genvar i;
generate
    // Count 1s in full 8-bit segments
    for (i = 0; i < 31; i = i + 1) begin : full_segments
        assign seg_counts[i] = in[i*8+0] + in[i*8+1] + in[i*8+2] + in[i*8+3] +
                              in[i*8+4] + in[i*8+5] + in[i*8+6] + in[i*8+7];
    end
    // Count 1s in last partial segment (7 bits)
    assign seg_counts[31] = in[248] + in[249] + in[250] + in[251] + 
                           in[252] + in[253] + in[254];
endgenerate

// First level of summation: sum pairs of segment counts
wire [4:0] level1 [0:15];
generate
    for (i = 0; i < 15; i = i + 1) begin : level1_adders
        assign level1[i] = seg_counts[i*2] + seg_counts[i*2+1];
    end
    // Handle the last odd segment
    assign level1[15] = seg_counts[30] + seg_counts[31];
endgenerate

// Second level of summation
wire [5:0] level2 [0:7];
generate
    for (i = 0; i < 7; i = i + 1) begin : level2_adders
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end
    // Handle last odd sum
    assign level2[7] = level1[14] + level1[15];
endgenerate

// Third level of summation
wire [6:0] level3 [0:3];
generate
    for (i = 0; i < 3; i = i + 1) begin : level3_adders
        assign level3[i] = level2[i*2] + level2[i*2+1];
    end
    // Handle last odd sum
    assign level3[3] = level2[6] + level2[7];
endgenerate

// Fourth level of summation
wire [7:0] level4 [0:1];
generate
    for (i = 0; i < 1; i = i + 1) begin : level4_adders
        assign level4[i] = level3[i*2] + level3[i*2+1];
    end
    // Handle last pair
    assign level4[1] = level3[2] + level3[3];
endgenerate

// Final sum
assign out = level4[0] + level4[1];

endmodule