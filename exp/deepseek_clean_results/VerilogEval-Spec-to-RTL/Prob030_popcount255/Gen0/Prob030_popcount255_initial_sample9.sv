module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);

// First level: count 1s in 3-bit chunks (85 chunks total)
wire [7:0] level1 [0:84];
genvar i;
generate
    for (i = 0; i < 85; i = i + 1) begin : level1_count
        if (i < 84) begin
            // Normal 3-bit chunk
            assign level1[i] = {5'b0, in[i*3] + in[i*3+1] + in[i*3+2]};
        end else begin
            // Last chunk is 6 bits (255 = 84*3 + 3)
            assign level1[i] = {5'b0, in[252] + in[253] + in[254]};
        end
    end
endgenerate

// Second level: sum adjacent counts (43 sums)
wire [7:0] level2 [0:42];
generate
    for (i = 0; i < 42; i = i + 1) begin : level2_sum
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end
    // Handle the odd count (85 inputs)
    assign level2[42] = level1[84];
endgenerate

// Third level: sum adjacent counts (22 sums)
wire [7:0] level3 [0:21];
generate
    for (i = 0; i < 21; i = i + 1) begin : level3_sum
        assign level3[i] = level2[i*2] + level2[i*2+1];
    end
    // Handle the odd count (43 inputs)
    assign level3[21] = level2[42];
endgenerate

// Fourth level: sum adjacent counts (11 sums)
wire [7:0] level4 [0:10];
generate
    for (i = 0; i < 10; i = i + 1) begin : level4_sum
        assign level4[i] = level3[i*2] + level3[i*2+1];
    end
    // Handle the odd count (22 inputs)
    assign level4[10] = level3[21];
endgenerate

// Fifth level: sum adjacent counts (6 sums)
wire [7:0] level5 [0:5];
generate
    for (i = 0; i < 5; i = i + 1) begin : level5_sum
        assign level5[i] = level4[i*2] + level4[i*2+1];
    end
    // Handle the odd count (11 inputs)
    assign level5[5] = level4[10];
endgenerate

// Sixth level: sum adjacent counts (3 sums)
wire [7:0] level6 [0:2];
generate
    for (i = 0; i < 2; i = i + 1) begin : level6_sum
        assign level6[i] = level5[i*2] + level5[i*2+1];
    end
    // Handle the odd count (6 inputs)
    assign level6[2] = level5[4] + level5[5];
endgenerate

// Seventh level: sum adjacent counts (2 sums)
wire [7:0] level7 [0:1];
assign level7[0] = level6[0] + level6[1];
assign level7[1] = level6[2];

// Final sum
assign out = level7[0] + level7[1];

endmodule