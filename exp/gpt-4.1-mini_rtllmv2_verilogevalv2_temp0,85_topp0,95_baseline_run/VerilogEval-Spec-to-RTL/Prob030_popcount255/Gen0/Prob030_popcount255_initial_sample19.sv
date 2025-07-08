module TopModule (
    input  [254:0] in,
    output [7:0]   out
);
    // First level: count bits in groups of 8 (except last group with 7 bits)
    wire [3:0] count0 [31:0]; // 32 groups (31 groups of 8 bits, 1 group of 7 bits)

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : count_8bits
            assign count0[i] = in[i*8 +: 8][0] + in[i*8 +: 8][1] + in[i*8 +: 8][2] + in[i*8 +: 8][3]
                             + in[i*8 +: 8][4] + in[i*8 +: 8][5] + in[i*8 +: 8][6] + in[i*8 +: 8][7];
        end
        // Last group: 7 bits
        assign count0[31] = in[248 +: 7][0] + in[248 +: 7][1] + in[248 +: 7][2] + in[248 +: 7][3]
                         + in[248 +: 7][4] + in[248 +: 7][5] + in[248 +: 7][6];
    endgenerate

    // Second level: sum pairs of count0 to get count1
    wire [4:0] count1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_pairs_0
            assign count1[i] = count0[2*i] + count0[2*i+1];
        end
    endgenerate

    // Third level: sum pairs of count1 to get count2
    wire [5:0] count2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_pairs_1
            assign count2[i] = count1[2*i] + count1[2*i+1];
        end
    endgenerate

    // Fourth level: sum pairs of count2 to get count3
    wire [6:0] count3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_pairs_2
            assign count3[i] = count2[2*i] + count2[2*i+1];
        end
    endgenerate

    // Fifth level: sum pairs of count3 to get count4
    wire [7:0] count4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_pairs_3
            assign count4[i] = count3[2*i] + count3[2*i+1];
        end
    endgenerate

    // Final sum: sum count4 to get total count
    wire [8:0] total_count = count4[0] + count4[1];

    // Assign the lower 8 bits to output (max is 255, fits in 8 bits)
    assign out = total_count[7:0];

endmodule