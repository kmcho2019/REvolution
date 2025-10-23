module TopModule(
    input  [254:0] in,
    output [7:0] out
);
    // First level: sum groups of 8 bits (except last group with 7 bits)
    wire [3:0] sum0 [31:0]; // max sum of 8 bits = 8 (4 bits needed)
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : sum8bits
            assign sum0[i] = in[i*8 +: 8][0] + in[i*8 +: 8][1] + in[i*8 +: 8][2] + in[i*8 +: 8][3]
                           + in[i*8 +: 8][4] + in[i*8 +: 8][5] + in[i*8 +: 8][6] + in[i*8 +: 8][7];
        end
        // Last group: 7 bits
        assign sum0[31] = in[248] + in[249] + in[250] + in[251] + in[252] + in[253] + in[254];
    endgenerate

    // Second level: sum groups of 4 sum0 outputs (each 4 bits)
    wire [6:0] sum1 [7:0]; // sum of four 4-bit numbers max = 4*8=32 (6 bits) plus margin
    generate
        for (i = 0; i < 7; i = i + 1) begin : sum4x4bits
            assign sum1[i] = sum0[i*4] + sum0[i*4+1] + sum0[i*4+2] + sum0[i*4+3];
        end
        // Last group (sum0[28..31]) - only 4 groups total in sum0[28 to 31]
        assign sum1[7] = sum0[28] + sum0[29] + sum0[30] + sum0[31];
    endgenerate

    // Third level: sum pairs of sum1 outputs
    wire [7:0] sum2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum2pair
            assign sum2[i] = sum1[i*2] + sum1[i*2 + 1];
        end
    endgenerate

    // Fourth level: sum pairs of sum2 outputs
    wire [8:0] sum3 [1:0];
    assign sum3[0] = sum2[0] + sum2[1];
    assign sum3[1] = sum2[2] + sum2[3];

    // Final sum
    wire [9:0] total_sum = sum3[0] + sum3[1];

    assign out = total_sum[7:0];  // 8-bit output, total_sum max 255 fits well

endmodule