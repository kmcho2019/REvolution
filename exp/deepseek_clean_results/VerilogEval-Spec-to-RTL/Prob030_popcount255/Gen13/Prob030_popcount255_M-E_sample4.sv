module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// Level 1: Process 255 bits into 85 3-bit sums (255/3)
wire [2:0] level1 [84:0];
genvar i;
generate
    for (i = 0; i < 85; i = i + 1) begin : L1
        assign level1[i] = (i*3+2 <= 254) ? 
                          (in[i*3] + in[i*3+1] + in[i*3+2]) : 
                          ((i*3+1 <= 254) ? 
                           (in[i*3] + in[i*3+1]) : 
                           in[i*3]);
    end
endgenerate

// Level 2: Combine 85 sums into 29 sums (85/3)
wire [3:0] level2 [28:0];
generate
    for (i = 0; i < 29; i = i + 1) begin : L2
        assign level2[i] = (i*3+2 < 85) ? 
                          (level1[i*3] + level1[i*3+1] + level1[i*3+2]) : 
                          ((i*3+1 < 85) ? 
                           (level1[i*3] + level1[i*3+1]) : 
                           level1[i*3]);
    end
endgenerate

// Level 3: Combine 29 sums into 10 sums (29/3)
wire [5:0] level3 [9:0];
generate
    for (i = 0; i < 10; i = i + 1) begin : L3
        assign level3[i] = (i*3+2 < 29) ? 
                          (level2[i*3] + level2[i*3+1] + level2[i*3+2]) : 
                          ((i*3+1 < 29) ? 
                           (level2[i*3] + level2[i*3+1]) : 
                           level2[i*3]);
    end
endgenerate

// Level 4: Combine 10 sums into 4 sums (10/3)
wire [6:0] level4 [3:0];
generate
    for (i = 0; i < 4; i = i + 1) begin : L4
        assign level4[i] = (i*3+2 < 10) ? 
                          (level3[i*3] + level3[i*3+1] + level3[i*3+2]) : 
                          ((i*3+1 < 10) ? 
                           (level3[i*3] + level3[i*3+1]) : 
                           level3[i*3]);
    end
endgenerate

// Level 5: Final combination (4 sums)
assign out = level4[0] + level4[1] + level4[2] + level4[3];

endmodule