module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate wires for each bit stage
    wire [8:0] rem_15, rem_14, rem_13, rem_12, rem_11, rem_10, rem_9, rem_8;
    wire [8:0] rem_7, rem_6, rem_5, rem_4, rem_3, rem_2, rem_1, rem_0;

    // Bit processing for each stage
    assign rem_15 = (A[15] ? {1'b0, A[15]} : 9'b0) >= {1'b0, B} ? 
                   ({1'b0, A[15]} - {1'b0, B}) : {1'b0, A[15]};
    assign result[15] = (A[15] ? {1'b0, A[15]} : 9'b0) >= {1'b0, B};

    assign rem_14 = {rem_15[7:0], A[14]} >= {1'b0, B} ? 
                   ({rem_15[7:0], A[14]} - {1'b0, B}) : {rem_15[7:0], A[14]};
    assign result[14] = {rem_15[7:0], A[14]} >= {1'b0, B};

    assign rem_13 = {rem_14[7:0], A[13]} >= {1'b0, B} ? 
                   ({rem_14[7:0], A[13]} - {1'b0, B}) : {rem_14[7:0], A[13]};
    assign result[13] = {rem_14[7:0], A[13]} >= {1'b0, B};

    assign rem_12 = {rem_13[7:0], A[12]} >= {1'b0, B} ? 
                   ({rem_13[7:0], A[12]} - {1'b0, B}) : {rem_13[7:0], A[12]};
    assign result[12] = {rem_13[7:0], A[12]} >= {1'b0, B};

    assign rem_11 = {rem_12[7:0], A[11]} >= {1'b0, B} ? 
                   ({rem_12[7:0], A[11]} - {1'b0, B}) : {rem_12[7:0], A[11]};
    assign result[11] = {rem_12[7:0], A[11]} >= {1'b0, B};

    assign rem_10 = {rem_11[7:0], A[10]} >= {1'b0, B} ? 
                   ({rem_11[7:0], A[10]} - {1'b0, B}) : {rem_11[7:0], A[10]};
    assign result[10] = {rem_11[7:0], A[10]} >= {1'b0, B};

    assign rem_9 = {rem_10[7:0], A[9]} >= {1'b0, B} ? 
                  ({rem_10[7:0], A[9]} - {1'b0, B}) : {rem_10[7:0], A[9]};
    assign result[9] = {rem_10[7:0], A[9]} >= {1'b0, B};

    assign rem_8 = {rem_9[7:0], A[8]} >= {1'b0, B} ? 
                  ({rem_9[7:0], A[8]} - {1'b0, B}) : {rem_9[7:0], A[8]};
    assign result[8] = {rem_9[7:0], A[8]} >= {1'b0, B};

    assign rem_7 = {rem_8[7:0], A[7]} >= {1'b0, B} ? 
                  ({rem_8[7:0], A[7]} - {1'b0, B}) : {rem_8[7:0], A[7]};
    assign result[7] = {rem_8[7:0], A[7]} >= {1'b0, B};

    assign rem_6 = {rem_7[7:0], A[6]} >= {1'b0, B} ? 
                  ({rem_7[7:0], A[6]} - {1'b0, B}) : {rem_7[7:0], A[6]};
    assign result[6] = {rem_7[7:0], A[6]} >= {1'b0, B};

    assign rem_5 = {rem_6[7:0], A[5]} >= {1'b0, B} ? 
                  ({rem_6[7:0], A[5]} - {1'b0, B}) : {rem_6[7:0], A[5]};
    assign result[5] = {rem_6[7:0], A[5]} >= {1'b0, B};

    assign rem_4 = {rem_5[7:0], A[4]} >= {1'b0, B} ? 
                  ({rem_5[7:0], A[4]} - {1'b0, B}) : {rem_5[7:0], A[4]};
    assign result[4] = {rem_5[7:0], A[4]} >= {1'b0, B};

    assign rem_3 = {rem_4[7:0], A[3]} >= {1'b0, B} ? 
                  ({rem_4[7:0], A[3]} - {1'b0, B}) : {rem_4[7:0], A[3]};
    assign result[3] = {rem_4[7:0], A[3]} >= {1'b0, B};

    assign rem_2 = {rem_3[7:0], A[2]} >= {1'b0, B} ? 
                  ({rem_3[7:0], A[2]} - {1'b0, B}) : {rem_3[7:0], A[2]};
    assign result[2] = {rem_3[7:0], A[2]} >= {1'b0, B};

    assign rem_1 = {rem_2[7:0], A[1]} >= {1'b0, B} ? 
                  ({rem_2[7:0], A[1]} - {1'b0, B}) : {rem_2[7:0], A[1]};
    assign result[1] = {rem_2[7:0], A[1]} >= {1'b0, B};

    assign rem_0 = {rem_1[7:0], A[0]} >= {1'b0, B} ? 
                  ({rem_1[7:0], A[0]} - {1'b0, B}) : {rem_1[7:0], A[0]};
    assign result[0] = {rem_1[7:0], A[0]} >= {1'b0, B};

    // Handle division by zero and final remainder output
    assign odd = (B == 8'b0) ? 16'b0 : {7'b0, rem_0};

endmodule