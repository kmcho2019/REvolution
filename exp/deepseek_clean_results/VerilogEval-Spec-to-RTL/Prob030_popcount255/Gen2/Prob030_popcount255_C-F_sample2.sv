module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// First level: count 1s in 8-bit segments (31 full + 1 partial)
wire [3:0] seg_counts [0:31];
genvar i;
generate
    // Full 8-bit segments
    for (i = 0; i < 31; i = i + 1) begin : seg_count
        assign seg_counts[i] = in[i*8 +: 8];
    end
    // Partial segment (7 bits)
    assign seg_counts[31] = in[248] + in[249] + in[250] + in[251] +
                           in[252] + in[253] + in[254];
endgenerate

// Second level: sum pairs (16 sums)
wire [4:0] level1 [0:15];
generate
    for (i = 0; i < 16; i = i + 1) begin : level1_sum
        assign level1[i] = seg_counts[i*2] + seg_counts[i*2+1];
    end
endgenerate

// Third level: sum pairs (8 sums)
wire [5:0] level2 [0:7];
generate
    for (i = 0; i < 8; i = i + 1) begin : level2_sum
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end
endgenerate

// Fourth level: sum pairs (4 sums)
wire [6:0] level3 [0:3];
generate
    for (i = 0; i < 4; i = i + 1) begin : level3_sum
        assign level3[i] = level2[i*2] + level2[i*2+1];
    end
endgenerate

// Fifth level: sum pairs (2 sums)
wire [7:0] level4 [0:1];
assign level4[0] = level3[0] + level3[1];
assign level4[1] = level3[2] + level3[3];

// Final sum
assign out = level4[0] + level4[1];

endmodule