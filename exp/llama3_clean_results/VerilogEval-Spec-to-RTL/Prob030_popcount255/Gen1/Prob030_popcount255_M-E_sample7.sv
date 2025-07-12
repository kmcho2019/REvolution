module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] partial_count0, partial_count1, partial_count2, partial_count3;
    wire [7:0] sum0, sum1, final_sum;

    // First stage: Count the number of '1's in each 16-bit segment
    assign partial_count0 = (
        in[15]  + in[14] + in[13] + in[12] + in[11] + in[10] + in[9]  + in[8]  +
        in[7]   + in[6]  + in[5]  + in[4]  + in[3]  + in[2]  + in[1]  + in[0]
    ) +
    (
        in[31]  + in[30] + in[29] + in[28] + in[27] + in[26] + in[25] + in[24] +
        in[23]  + in[22] + in[21] + in[20] + in[19] + in[18] + in[17] + in[16]
    );

    assign partial_count1 = (
        in[47]  + in[46] + in[45] + in[44] + in[43] + in[42] + in[41] + in[40] +
        in[39]  + in[38] + in[37] + in[36] + in[35] + in[34] + in[33] + in[32]
    ) +
    (
        in[63]  + in[62] + in[61] + in[60] + in[59] + in[58] + in[57] + in[56] +
        in[55]  + in[54] + in[53] + in[52] + in[51] + in[50] + in[49] + in[48]
    );

    assign partial_count2 = (
        in[79]  + in[78] + in[77] + in[76] + in[75] + in[74] + in[73] + in[72] +
        in[71]  + in[70] + in[69] + in[68] + in[67] + in[66] + in[65] + in[64]
    ) +
    (
        in[95]  + in[94] + in[93] + in[92] + in[91] + in[90] + in[89] + in[88] +
        in[87]  + in[86] + in[85] + in[84] + in[83] + in[82] + in[81] + in[80]
    );

    assign partial_count3 = (
        in[111] + in[110] + in[109] + in[108] + in[107] + in[106] + in[105] + in[104] +
        in[103] + in[102] + in[101] + in[100] + in[99]  + in[98]  + in[97]  + in[96]
    ) +
    (
        in[127] + in[126] + in[125] + in[124] + in[123] + in[122] + in[121] + in[120] +
        in[119] + in[118] + in[117] + in[116] + in[115] + in[114] + in[113] + in[112]
    );

    // Second stage: Sum the partial counts
    assign sum0 = partial_count0 + partial_count1;
    assign sum1 = partial_count2 + partial_count3;

    // Third stage: Combine the sums
    assign final_sum = sum0 + sum1;

    assign out = final_sum;

endmodule