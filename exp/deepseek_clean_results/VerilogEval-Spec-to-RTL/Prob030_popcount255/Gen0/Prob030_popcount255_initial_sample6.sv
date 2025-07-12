module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// First stage: count 1s in groups of 3 bits (85 groups)
wire [7:0] stage1 [0:84];
genvar i;
generate
    for (i = 0; i < 85; i = i + 1) begin : STAGE1
        if (i < 84) begin
            assign stage1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
        end else begin
            // Last group has only 3 bits (255 = 84*3 + 3)
            assign stage1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
        end
    end
endgenerate

// Second stage: sum groups of 3 counts (28 groups of 3 counts + 1 leftover)
wire [7:0] stage2 [0:28];
generate
    for (i = 0; i < 28; i = i + 1) begin : STAGE2
        assign stage2[i] = stage1[i*3] + stage1[i*3+1] + stage1[i*3+2];
    end
    // Leftover count
    assign stage2[28] = stage1[84];
endgenerate

// Third stage: sum groups of 3 counts (9 groups of 3 counts + 1 leftover)
wire [7:0] stage3 [0:9];
generate
    for (i = 0; i < 9; i = i + 1) begin : STAGE3
        assign stage3[i] = stage2[i*3] + stage2[i*3+1] + stage2[i*3+2];
    end
    // Leftover counts
    assign stage3[9] = stage2[27] + stage2[28];
endgenerate

// Fourth stage: sum remaining counts
wire [7:0] stage4 [0:3];
generate
    for (i = 0; i < 3; i = i + 1) begin : STAGE4
        assign stage4[i] = stage3[i*3] + stage3[i*3+1] + stage3[i*3+2];
    end
    // Leftover count
    assign stage4[3] = stage3[9];
endgenerate

// Final stage: sum all remaining counts
assign out = stage4[0] + stage4[1] + stage4[2] + stage4[3];

endmodule