module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [8:0] final_remainder;
    wire [15:0] quotient;

    // Iterative division logic
    wire [8:0] rem0 = {8'b0, A[15]};
    wire sub0 = (rem0 >= B);
    wire [8:0] diff0 = sub0 ? (rem0 - B) : rem0;
    assign quotient[15] = sub0;

    wire [8:0] rem1 = {diff0[7:0], A[14]};
    wire sub1 = (rem1 >= B);
    wire [8:0] diff1 = sub1 ? (rem1 - B) : rem1;
    assign quotient[14] = sub1;

    wire [8:0] rem2 = {diff1[7:0], A[13]};
    wire sub2 = (rem2 >= B);
    wire [8:0] diff2 = sub2 ? (rem2 - B) : rem2;
    assign quotient[13] = sub2;

    wire [8:0] rem3 = {diff2[7:0], A[12]};
    wire sub3 = (rem3 >= B);
    wire [8:0] diff3 = sub3 ? (rem3 - B) : rem3;
    assign quotient[12] = sub3;

    wire [8:0] rem4 = {diff3[7:0], A[11]};
    wire sub4 = (rem4 >= B);
    wire [8:0] diff4 = sub4 ? (rem4 - B) : rem4;
    assign quotient[11] = sub4;

    wire [8:0] rem5 = {diff4[7:0], A[10]};
    wire sub5 = (rem5 >= B);
    wire [8:0] diff5 = sub5 ? (rem5 - B) : rem5;
    assign quotient[10] = sub5;

    wire [8:0] rem6 = {diff5[7:0], A[9]};
    wire sub6 = (rem6 >= B);
    wire [8:0] diff6 = sub6 ? (rem6 - B) : rem6;
    assign quotient[9] = sub6;

    wire [8:0] rem7 = {diff6[7:0], A[8]};
    wire sub7 = (rem7 >= B);
    wire [8:0] diff7 = sub7 ? (rem7 - B) : rem7;
    assign quotient[8] = sub7;

    wire [8:0] rem8 = {diff7[7:0], A[7]};
    wire sub8 = (rem8 >= B);
    wire [8:0] diff8 = sub8 ? (rem8 - B) : rem8;
    assign quotient[7] = sub8;

    wire [8:0] rem9 = {diff8[7:0], A[6]};
    wire sub9 = (rem9 >= B);
    wire [8:0] diff9 = sub9 ? (rem9 - B) : rem9;
    assign quotient[6] = sub9;

    wire [8:0] rem10 = {diff9[7:0], A[5]};
    wire sub10 = (rem10 >= B);
    wire [8:0] diff10 = sub10 ? (rem10 - B) : rem10;
    assign quotient[5] = sub10;

    wire [8:0] rem11 = {diff10[7:0], A[4]};
    wire sub11 = (rem11 >= B);
    wire [8:0] diff11 = sub11 ? (rem11 - B) : rem11;
    assign quotient[4] = sub11;

    wire [8:0] rem12 = {diff11[7:0], A[3]};
    wire sub12 = (rem12 >= B);
    wire [8:0] diff12 = sub12 ? (rem12 - B) : rem12;
    assign quotient[3] = sub12;

    wire [8:0] rem13 = {diff12[7:0], A[2]};
    wire sub13 = (rem13 >= B);
    wire [8:0] diff13 = sub13 ? (rem13 - B) : rem13;
    assign quotient[2] = sub13;

    wire [8:0] rem14 = {diff13[7:0], A[1]};
    wire sub14 = (rem14 >= B);
    wire [8:0] diff14 = sub14 ? (rem14 - B) : rem14;
    assign quotient[1] = sub14;

    wire [8:0] rem15 = {diff14[7:0], A[0]};
    wire sub15 = (rem15 >= B);
    wire [8:0] diff15 = sub15 ? (rem15 - B) : rem15;
    assign quotient[0] = sub15;

    assign result = quotient;
    assign odd = {8'b0, diff15[7:0]}; // Zero-extend to 16 bits

endmodule