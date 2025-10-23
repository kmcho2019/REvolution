module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Break input into 32 groups of 8 bits plus one group of 7 bits
    wire [7:0] partial_counts [0:31];

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : PARTIAL_COUNT_8BITS
            // Use reduction plus to count bits in each 8-bit chunk
            assign partial_counts[i] = in[(i+1)*8-1 : i*8] - {{7{1'b0}},1'b0} + 0; // Explicit style for clarity
            assign partial_counts[i] = {1'b0, in[(i+1)*8-1 : i*8]}[0] + {1'b0, in[(i+1)*8-1 : i*8]}[1] + {1'b0, in[(i+1)*8-1 : i*8]}[2] + {1'b0, in[(i+1)*8-1 : i*8]}[3] + {1'b0, in[(i+1)*8-1 : i*8]}[4] + {1'b0, in[(i+1)*8-1 : i*8]}[5] + {1'b0, in[(i+1)*8-1 : i*8]}[6] + {1'b0, in[(i+1)*8-1 : i*8]}[7];
        end
        // Last group: 7 bits
        assign partial_counts[31] = in[254:248][0] + in[254:248][1] + in[254:248][2] + in[254:248][3] + in[254:248][4] + in[254:248][5] + in[254:248][6];
    endgenerate

    // Sum partial counts hierarchically to reduce logic depth
    wire [10:0] sum_level1 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : SUM_LEVEL1
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    wire [11:0] sum_level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : SUM_LEVEL2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    wire [12:0] sum_level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUM_LEVEL3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    wire [13:0] sum_level4 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : SUM_LEVEL4
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
        end
    endgenerate

    // Final sum plus the last partial count
    wire [14:0] final_sum;
    assign final_sum = sum_level4[0] + sum_level4[1] + partial_counts[31];

    // Output is the lower 8 bits since max count is 255 (max 8 bits)
    assign out = final_sum[7:0];

endmodule