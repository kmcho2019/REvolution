module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Stage 0
    wire [7:0] rem0 = {7'b0, A[15]};
    wire gt0 = rem0 >= B;
    wire [7:0] diff0 = rem0 - B;
    assign result[15] = gt0;
    wire [7:0] rem1 = gt0 ? diff0 : rem0;

    // Stage 1
    wire [7:0] rem1_ext = {rem1[6:0], A[14]};
    wire gt1 = rem1_ext >= B;
    wire [7:0] diff1 = rem1_ext - B;
    assign result[14] = gt1;
    wire [7:0] rem2 = gt1 ? diff1 : rem1_ext;

    // Stage 2
    wire [7:0] rem2_ext = {rem2[6:0], A[13]};
    wire gt2 = rem2_ext >= B;
    wire [7:0] diff2 = rem2_ext - B;
    assign result[13] = gt2;
    wire [7:0] rem3 = gt2 ? diff2 : rem2_ext;

    // Stage 3
    wire [7:0] rem3_ext = {rem3[6:0], A[12]};
    wire gt3 = rem3_ext >= B;
    wire [7:0] diff3 = rem3_ext - B;
    assign result[12] = gt3;
    wire [7:0] rem4 = gt3 ? diff3 : rem3_ext;

    // Stage 4
    wire [7:0] rem4_ext = {rem4[6:0], A[11]};
    wire gt4 = rem4_ext >= B;
    wire [7:0] diff4 = rem4_ext - B;
    assign result[11] = gt4;
    wire [7:0] rem5 = gt4 ? diff4 : rem4_ext;

    // Stage 5
    wire [7:0] rem5_ext = {rem5[6:0], A[10]};
    wire gt5 = rem5_ext >= B;
    wire [7:0] diff5 = rem5_ext - B;
    assign result[10] = gt5;
    wire [7:0] rem6 = gt5 ? diff5 : rem5_ext;

    // Stage 6
    wire [7:0] rem6_ext = {rem6[6:0], A[9]};
    wire gt6 = rem6_ext >= B;
    wire [7:0] diff6 = rem6_ext - B;
    assign result[9] = gt6;
    wire [7:0] rem7 = gt6 ? diff6 : rem6_ext;

    // Stage 7
    wire [7:0] rem7_ext = {rem7[6:0], A[8]};
    wire gt7 = rem7_ext >= B;
    wire [7:0] diff7 = rem7_ext - B;
    assign result[8] = gt7;
    wire [7:0] rem8 = gt7 ? diff7 : rem7_ext;

    // Stage 8
    wire [7:0] rem8_ext = {rem8[6:0], A[7]};
    wire gt8 = rem8_ext >= B;
    wire [7:0] diff8 = rem8_ext - B;
    assign result[7] = gt8;
    wire [7:0] rem9 = gt8 ? diff8 : rem8_ext;

    // Stage 9
    wire [7:0] rem9_ext = {rem9[6:0], A[6]};
    wire gt9 = rem9_ext >= B;
    wire [7:0] diff9 = rem9_ext - B;
    assign result[6] = gt9;
    wire [7:0] rem10 = gt9 ? diff9 : rem9_ext;

    // Stage 10
    wire [7:0] rem10_ext = {rem10[6:0], A[5]};
    wire gt10 = rem10_ext >= B;
    wire [7:0] diff10 = rem10_ext - B;
    assign result[5] = gt10;
    wire [7:0] rem11 = gt10 ? diff10 : rem10_ext;

    // Stage 11
    wire [7:0] rem11_ext = {rem11[6:0], A[4]};
    wire gt11 = rem11_ext >= B;
    wire [7:0] diff11 = rem11_ext - B;
    assign result[4] = gt11;
    wire [7:0] rem12 = gt11 ? diff11 : rem11_ext;

    // Stage 12
    wire [7:0] rem12_ext = {rem12[6:0], A[3]};
    wire gt12 = rem12_ext >= B;
    wire [7:0] diff12 = rem12_ext - B;
    assign result[3] = gt12;
    wire [7:0] rem13 = gt12 ? diff12 : rem12_ext;

    // Stage 13
    wire [7:0] rem13_ext = {rem13[6:0], A[2]};
    wire gt13 = rem13_ext >= B;
    wire [7:0] diff13 = rem13_ext - B;
    assign result[2] = gt13;
    wire [7:0] rem14 = gt13 ? diff13 : rem13_ext;

    // Stage 14
    wire [7:0] rem14_ext = {rem14[6:0], A[1]};
    wire gt14 = rem14_ext >= B;
    wire [7:0] diff14 = rem14_ext - B;
    assign result[1] = gt14;
    wire [7:0] rem15 = gt14 ? diff14 : rem14_ext;

    // Stage 15
    wire [7:0] rem15_ext = {rem15[6:0], A[0]};
    wire gt15 = rem15_ext >= B;
    wire [7:0] diff15 = rem15_ext - B;
    assign result[0] = gt15;
    wire [7:0] final_rem = gt15 ? diff15 : rem15_ext;

    assign odd = {8'b0, final_rem};

endmodule