module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Remainder wires (9-bit: 8 bits + 1 comparison bit)
    wire [8:0] rem15, rem14, rem13, rem12, rem11, rem10, rem9, rem8;
    wire [8:0] rem7, rem6, rem5, rem4, rem3, rem2, rem1, rem0;

    // Stage 15 (MSB)
    assign rem15 = {1'b0, A[15]};
    assign result[15] = (rem15 >= {1'b0, B});

    // Stage 14
    assign rem14 = result[15] ? (rem15 - {1'b0, B}) << 1 | {8'b0, A[14]} : 
                                 rem15 << 1 | {8'b0, A[14]};
    assign result[14] = (rem14 >= {1'b0, B});

    // Stage 13
    assign rem13 = result[14] ? (rem14 - {1'b0, B}) << 1 | {8'b0, A[13]} : 
                                 rem14 << 1 | {8'b0, A[13]};
    assign result[13] = (rem13 >= {1'b0, B});

    // Stage 12
    assign rem12 = result[13] ? (rem13 - {1'b0, B}) << 1 | {8'b0, A[12]} : 
                                 rem13 << 1 | {8'b0, A[12]};
    assign result[12] = (rem12 >= {1'b0, B});

    // Stage 11
    assign rem11 = result[12] ? (rem12 - {1'b0, B}) << 1 | {8'b0, A[11]} : 
                                 rem12 << 1 | {8'b0, A[11]};
    assign result[11] = (rem11 >= {1'b0, B});

    // Stage 10
    assign rem10 = result[11] ? (rem11 - {1'b0, B}) << 1 | {8'b0, A[10]} : 
                                 rem11 << 1 | {8'b0, A[10]};
    assign result[10] = (rem10 >= {1'b0, B});

    // Stage 9
    assign rem9 = result[10] ? (rem10 - {1'b0, B}) << 1 | {8'b0, A[9]} : 
                                rem10 << 1 | {8'b0, A[9]};
    assign result[9] = (rem9 >= {1'b0, B});

    // Stage 8
    assign rem8 = result[9] ? (rem9 - {1'b0, B}) << 1 | {8'b0, A[8]} : 
                               rem9 << 1 | {8'b0, A[8]};
    assign result[8] = (rem8 >= {1'b0, B});

    // Stage 7
    assign rem7 = result[8] ? (rem8 - {1'b0, B}) << 1 | {8'b0, A[7]} : 
                               rem8 << 1 | {8'b0, A[7]};
    assign result[7] = (rem7 >= {1'b0, B});

    // Stage 6
    assign rem6 = result[7] ? (rem7 - {1'b0, B}) << 1 | {8'b0, A[6]} : 
                               rem7 << 1 | {8'b0, A[6]};
    assign result[6] = (rem6 >= {1'b0, B});

    // Stage 5
    assign rem5 = result[6] ? (rem6 - {1'b0, B}) << 1 | {8'b0, A[5]} : 
                               rem6 << 1 | {8'b0, A[5]};
    assign result[5] = (rem5 >= {1'b0, B});

    // Stage 4
    assign rem4 = result[5] ? (rem5 - {1'b0, B}) << 1 | {8'b0, A[4]} : 
                               rem5 << 1 | {8'b0, A[4]};
    assign result[4] = (rem4 >= {1'b0, B});

    // Stage 3
    assign rem3 = result[4] ? (rem4 - {1'b0, B}) << 1 | {8'b0, A[3]} : 
                               rem4 << 1 | {8'b0, A[3]};
    assign result[3] = (rem3 >= {1'b0, B});

    // Stage 2
    assign rem2 = result[3] ? (rem3 - {1'b0, B}) << 1 | {8'b0, A[2]} : 
                               rem3 << 1 | {8'b0, A[2]};
    assign result[2] = (rem2 >= {1'b0, B});

    // Stage 1
    assign rem1 = result[2] ? (rem2 - {1'b0, B}) << 1 | {8'b0, A[1]} : 
                               rem2 << 1 | {8'b0, A[1]};
    assign result[1] = (rem1 >= {1'b0, B});

    // Stage 0 (LSB)
    assign rem0 = result[1] ? (rem1 - {1'b0, B}) << 1 | {8'b0, A[0]} : 
                               rem1 << 1 | {8'b0, A[0]};
    assign result[0] = (rem0 >= {1'b0, B});

    // Final remainder output with zero-division check
    assign odd = (B == 8'b0) ? 8'b0 : 
                 result[0] ? (rem0 - {1'b0, B})[7:0] : rem0[7:0];

endmodule