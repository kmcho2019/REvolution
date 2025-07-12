module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in groups of 8 bits (32 groups)
    wire [3:0] partial_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BITS
            wire [7:0] group = in[i*8 +: 8];
            assign partial_counts[i] = group[0] + group[1] + group[2] + group[3] + 
                                     group[4] + group[5] + group[6] + group[7];
        end
        // Handle last group (7 bits)
        wire [6:0] last_group = in[248 +: 7];
        assign partial_counts[31] = last_group[0] + last_group[1] + last_group[2] + last_group[3] + 
                                  last_group[4] + last_group[5] + last_group[6];
    endgenerate

    // Second level: Sum in binary tree fashion
    wire [7:0] sum1 = partial_counts[0] + partial_counts[1] + partial_counts[2] + partial_counts[3];
    wire [7:0] sum2 = partial_counts[4] + partial_counts[5] + partial_counts[6] + partial_counts[7];
    wire [7:0] sum3 = partial_counts[8] + partial_counts[9] + partial_counts[10] + partial_counts[11];
    wire [7:0] sum4 = partial_counts[12] + partial_counts[13] + partial_counts[14] + partial_counts[15];
    wire [7:0] sum5 = partial_counts[16] + partial_counts[17] + partial_counts[18] + partial_counts[19];
    wire [7:0] sum6 = partial_counts[20] + partial_counts[21] + partial_counts[22] + partial_counts[23];
    wire [7:0] sum7 = partial_counts[24] + partial_counts[25] + partial_counts[26] + partial_counts[27];
    wire [7:0] sum8 = partial_counts[28] + partial_counts[29] + partial_counts[30] + partial_counts[31];

    // Third level
    wire [7:0] sumA = sum1 + sum2;
    wire [7:0] sumB = sum3 + sum4;
    wire [7:0] sumC = sum5 + sum6;
    wire [7:0] sumD = sum7 + sum8;

    // Final level
    wire [7:0] sumAB = sumA + sumB;
    wire [7:0] sumCD = sumC + sumD;

    assign out = sumAB + sumCD;

endmodule