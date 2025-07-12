module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);

// First level: count 1s in 8-bit chunks (31 full chunks + 7 remaining bits)
wire [7:0] level1 [0:31];
genvar i;
generate
    for (i = 0; i < 31; i = i + 1) begin : level1_count
        assign level1[i] = in[i*8+0] + in[i*8+1] + in[i*8+2] + in[i*8+3] +
                          in[i*8+4] + in[i*8+5] + in[i*8+6] + in[i*8+7];
    end
    // Last partial chunk (7 bits)
    assign level1[31] = in[248] + in[249] + in[250] + in[251] +
                        in[252] + in[253] + in[254];
endgenerate

// Second level: sum adjacent counts (16 sums)
wire [7:0] level2 [0:15];
generate
    for (i = 0; i < 15; i = i + 1) begin : level2_sum
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end
    assign level2[15] = level1[30] + level1[31];
endgenerate

// Third level: sum adjacent counts (8 sums)
wire [7:0] level3 [0:7];
generate
    for (i = 0; i < 7; i = i + 1) begin : level3_sum
        assign level3[i] = level2[i*2] + level2[i*2+1];
    end
    assign level3[7] = level2[14] + level2[15];
endgenerate

// Fourth level: sum adjacent counts (4 sums)
wire [7:0] level4 [0:3];
generate
    for (i = 0; i < 3; i = i + 1) begin : level4_sum
        assign level4[i] = level3[i*2] + level3[i*2+1];
    end
    assign level4[3] = level3[6] + level3[7];
endgenerate

// Fifth level: sum adjacent counts (2 sums)
wire [7:0] level5 [0:1];
assign level5[0] = level4[0] + level4[1];
assign level5[1] = level4[2] + level4[3];

// Final sum
assign out = level5[0] + level5[1];

endmodule