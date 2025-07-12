module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate remainders for each bit position
    wire [8:0] rem15, rem14, rem13, rem12, rem11, rem10, rem9, rem8;
    wire [8:0] rem7, rem6, rem5, rem4, rem3, rem2, rem1, rem0;

    // Bit 15
    wire [8:0] shifted_rem15 = {1'b0, A[15]};
    wire do_sub15 = (shifted_rem15 >= B);
    assign rem15 = do_sub15 ? (shifted_rem15 - B) : shifted_rem15;
    assign result[15] = do_sub15;

    // Bit 14
    wire [8:0] shifted_rem14 = {rem15[7:0], A[14]};
    wire do_sub14 = (shifted_rem14 >= B);
    assign rem14 = do_sub14 ? (shifted_rem14 - B) : shifted_rem14;
    assign result[14] = do_sub14;

    // Bit 13
    wire [8:0] shifted_rem13 = {rem14[7:0], A[13]};
    wire do_sub13 = (shifted_rem13 >= B);
    assign rem13 = do_sub13 ? (shifted_rem13 - B) : shifted_rem13;
    assign result[13] = do_sub13;

    // Bit 12
    wire [8:0] shifted_rem12 = {rem13[7:0], A[12]};
    wire do_sub12 = (shifted_rem12 >= B);
    assign rem12 = do_sub12 ? (shifted_rem12 - B) : shifted_rem12;
    assign result[12] = do_sub12;

    // Bit 11
    wire [8:0] shifted_rem11 = {rem12[7:0], A[11]};
    wire do_sub11 = (shifted_rem11 >= B);
    assign rem11 = do_sub11 ? (shifted_rem11 - B) : shifted_rem11;
    assign result[11] = do_sub11;

    // Bit 10
    wire [8:0] shifted_rem10 = {rem11[7:0], A[10]};
    wire do_sub10 = (shifted_rem10 >= B);
    assign rem10 = do_sub10 ? (shifted_rem10 - B) : shifted_rem10;
    assign result[10] = do_sub10;

    // Bit 9
    wire [8:0] shifted_rem9 = {rem10[7:0], A[9]};
    wire do_sub9 = (shifted_rem9 >= B);
    assign rem9 = do_sub9 ? (shifted_rem9 - B) : shifted_rem9;
    assign result[9] = do_sub9;

    // Bit 8
    wire [8:0] shifted_rem8 = {rem9[7:0], A[8]};
    wire do_sub8 = (shifted_rem8 >= B);
    assign rem8 = do_sub8 ? (shifted_rem8 - B) : shifted_rem8;
    assign result[8] = do_sub8;

    // Bit 7
    wire [8:0] shifted_rem7 = {rem8[7:0], A[7]};
    wire do_sub7 = (shifted_rem7 >= B);
    assign rem7 = do_sub7 ? (shifted_rem7 - B) : shifted_rem7;
    assign result[7] = do_sub7;

    // Bit 6
    wire [8:0] shifted_rem6 = {rem7[7:0], A[6]};
    wire do_sub6 = (shifted_rem6 >= B);
    assign rem6 = do_sub6 ? (shifted_rem6 - B) : shifted_rem6;
    assign result[6] = do_sub6;

    // Bit 5
    wire [8:0] shifted_rem5 = {rem6[7:0], A[5]};
    wire do_sub5 = (shifted_rem5 >= B);
    assign rem5 = do_sub5 ? (shifted_rem5 - B) : shifted_rem5;
    assign result[5] = do_sub5;

    // Bit 4
    wire [8:0] shifted_rem4 = {rem5[7:0], A[4]};
    wire do_sub4 = (shifted_rem4 >= B);
    assign rem4 = do_sub4 ? (shifted_rem4 - B) : shifted_rem4;
    assign result[4] = do_sub4;

    // Bit 3
    wire [8:0] shifted_rem3 = {rem4[7:0], A[3]};
    wire do_sub3 = (shifted_rem3 >= B);
    assign rem3 = do_sub3 ? (shifted_rem3 - B) : shifted_rem3;
    assign result[3] = do_sub3;

    // Bit 2
    wire [8:0] shifted_rem2 = {rem3[7:0], A[2]};
    wire do_sub2 = (shifted_rem2 >= B);
    assign rem2 = do_sub2 ? (shifted_rem2 - B) : shifted_rem2;
    assign result[2] = do_sub2;

    // Bit 1
    wire [8:0] shifted_rem1 = {rem2[7:0], A[1]};
    wire do_sub1 = (shifted_rem1 >= B);
    assign rem1 = do_sub1 ? (shifted_rem1 - B) : shifted_rem1;
    assign result[1] = do_sub1;

    // Bit 0
    wire [8:0] shifted_rem0 = {rem1[7:0], A[0]};
    wire do_sub0 = (shifted_rem0 >= B);
    assign rem0 = do_sub0 ? (shifted_rem0 - B) : shifted_rem0;
    assign result[0] = do_sub0;

    // Final remainder (16-bit output as specified)
    assign odd = {8'b0, rem0[7:0]};

endmodule