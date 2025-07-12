module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate remainder wires
    wire [8:0] rem0, rem1, rem2, rem3, rem4, rem5, rem6, rem7;
    wire [8:0] rem8, rem9, rem10, rem11, rem12, rem13, rem14, rem15;
    
    // Quotient bits
    wire q15, q14, q13, q12, q11, q10, q9, q8;
    wire q7, q6, q5, q4, q3, q2, q1, q0;
    
    // Step 0: MSB
    assign rem0 = {1'b0, A[15]};
    assign q15 = (rem0 >= {1'b0, B});
    assign rem1 = q15 ? (rem0 - B) : rem0;
    
    // Subsequent steps
    assign rem2 = {rem1[7:0], A[14]};
    assign q14 = (rem2 >= {1'b0, B});
    assign rem3 = q14 ? (rem2 - B) : rem2;
    
    assign rem4 = {rem3[7:0], A[13]};
    assign q13 = (rem4 >= {1'b0, B});
    assign rem5 = q13 ? (rem4 - B) : rem4;
    
    assign rem6 = {rem5[7:0], A[12]};
    assign q12 = (rem6 >= {1'b0, B});
    assign rem7 = q12 ? (rem6 - B) : rem6;
    
    assign rem8 = {rem7[7:0], A[11]};
    assign q11 = (rem8 >= {1'b0, B});
    assign rem9 = q11 ? (rem8 - B) : rem8;
    
    assign rem10 = {rem9[7:0], A[10]};
    assign q10 = (rem10 >= {1'b0, B});
    assign rem11 = q10 ? (rem10 - B) : rem10;
    
    assign rem12 = {rem11[7:0], A[9]};
    assign q9 = (rem12 >= {1'b0, B});
    assign rem13 = q9 ? (rem12 - B) : rem12;
    
    assign rem14 = {rem13[7:0], A[8]};
    assign q8 = (rem14 >= {1'b0, B});
    assign rem15 = q8 ? (rem14 - B) : rem14;
    
    // Lower byte steps
    wire [8:0] rem16, rem17, rem18, rem19, rem20, rem21, rem22, rem23;
    
    assign rem16 = {rem15[7:0], A[7]};
    assign q7 = (rem16 >= {1'b0, B});
    assign rem17 = q7 ? (rem16 - B) : rem16;
    
    assign rem18 = {rem17[7:0], A[6]};
    assign q6 = (rem18 >= {1'b0, B});
    assign rem19 = q6 ? (rem18 - B) : rem18;
    
    assign rem20 = {rem19[7:0], A[5]};
    assign q5 = (rem20 >= {1'b0, B});
    assign rem21 = q5 ? (rem20 - B) : rem20;
    
    assign rem22 = {rem21[7:0], A[4]};
    assign q4 = (rem22 >= {1'b0, B});
    assign rem23 = q4 ? (rem22 - B) : rem22;
    
    wire [8:0] rem24, rem25, rem26, rem27, rem28, rem29, rem30, rem31;
    
    assign rem24 = {rem23[7:0], A[3]};
    assign q3 = (rem24 >= {1'b0, B});
    assign rem25 = q3 ? (rem24 - B) : rem24;
    
    assign rem26 = {rem25[7:0], A[2]};
    assign q2 = (rem26 >= {1'b0, B});
    assign rem27 = q2 ? (rem26 - B) : rem26;
    
    assign rem28 = {rem27[7:0], A[1]};
    assign q1 = (rem28 >= {1'b0, B});
    assign rem29 = q1 ? (rem28 - B) : rem28;
    
    assign rem30 = {rem29[7:0], A[0]};
    assign q0 = (rem30 >= {1'b0, B});
    assign rem31 = q0 ? (rem30 - B) : rem30;
    
    // Output assignments
    assign result = {q15, q14, q13, q12, q11, q10, q9, q8,
                    q7, q6, q5, q4, q3, q2, q1, q0};
    assign odd = (B == 8'b0) ? A[7:0] : rem31[7:0];

endmodule