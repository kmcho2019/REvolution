module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate remainders
    wire [8:0] r15, r14, r13, r12, r11, r10, r9, r8;
    wire [8:0] r7, r6, r5, r4, r3, r2, r1, r0;

    // Stage 15
    wire [8:0] in15 = {8'b0, A[15]};
    assign result[15] = (in15 >= B);
    assign r15 = result[15] ? (in15 - B) : in15;

    // Stage 14
    wire [8:0] in14 = {r15[7:0], A[14]};
    assign result[14] = (in14 >= B);
    assign r14 = result[14] ? (in14 - B) : in14;

    // Stage 13
    wire [8:0] in13 = {r14[7:0], A[13]};
    assign result[13] = (in13 >= B);
    assign r13 = result[13] ? (in13 - B) : in13;

    // Stage 12
    wire [8:0] in12 = {r13[7:0], A[12]};
    assign result[12] = (in12 >= B);
    assign r12 = result[12] ? (in12 - B) : in12;

    // Stage 11
    wire [8:0] in11 = {r12[7:0], A[11]};
    assign result[11] = (in11 >= B);
    assign r11 = result[11] ? (in11 - B) : in11;

    // Stage 10
    wire [8:0] in10 = {r11[7:0], A[10]};
    assign result[10] = (in10 >= B);
    assign r10 = result[10] ? (in10 - B) : in10;

    // Stage 9
    wire [8:0] in9 = {r10[7:0], A[9]};
    assign result[9] = (in9 >= B);
    assign r9 = result[9] ? (in9 - B) : in9;

    // Stage 8
    wire [8:0] in8 = {r9[7:0], A[8]};
    assign result[8] = (in8 >= B);
    assign r8 = result[8] ? (in8 - B) : in8;

    // Stage 7
    wire [8:0] in7 = {r8[7:0], A[7]};
    assign result[7] = (in7 >= B);
    assign r7 = result[7] ? (in7 - B) : in7;

    // Stage 6
    wire [8:0] in6 = {r7[7:0], A[6]};
    assign result[6] = (in6 >= B);
    assign r6 = result[6] ? (in6 - B) : in6;

    // Stage 5
    wire [8:0] in5 = {r6[7:0], A[5]};
    assign result[5] = (in5 >= B);
    assign r5 = result[5] ? (in5 - B) : in5;

    // Stage 4
    wire [8:0] in4 = {r5[7:0], A[4]};
    assign result[4] = (in4 >= B);
    assign r4 = result[4] ? (in4 - B) : in4;

    // Stage 3
    wire [8:0] in3 = {r4[7:0], A[3]};
    assign result[3] = (in3 >= B);
    assign r3 = result[3] ? (in3 - B) : in3;

    // Stage 2
    wire [8:0] in2 = {r3[7:0], A[2]};
    assign result[2] = (in2 >= B);
    assign r2 = result[2] ? (in2 - B) : in2;

    // Stage 1
    wire [8:0] in1 = {r2[7:0], A[1]};
    assign result[1] = (in1 >= B);
    assign r1 = result[1] ? (in1 - B) : in1;

    // Stage 0
    wire [8:0] in0 = {r1[7:0], A[0]};
    assign result[0] = (in0 >= B);
    assign r0 = result[0] ? (in0 - B) : in0;

    // Final remainder output
    assign odd = {8'b0, r0[7:0]};

endmodule