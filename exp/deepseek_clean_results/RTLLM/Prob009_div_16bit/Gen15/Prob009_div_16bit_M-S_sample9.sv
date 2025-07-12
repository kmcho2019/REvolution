module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    wire [8:0] step0 = {1'b0, A[15]};
    wire [7:0] rem0 = (step0 >= {1'b0, B}) ? (step0 - B) : step0[7:0];
    
    wire [8:0] step1 = {rem0, A[14]};
    wire [7:0] rem1 = (step1 >= {1'b0, B}) ? (step1 - B) : step1[7:0];
    
    wire [8:0] step2 = {rem1, A[13]};
    wire [7:0] rem2 = (step2 >= {1'b0, B}) ? (step2 - B) : step2[7:0];
    
    wire [8:0] step3 = {rem2, A[12]};
    wire [7:0] rem3 = (step3 >= {1'b0, B}) ? (step3 - B) : step3[7:0];
    
    wire [8:0] step4 = {rem3, A[11]};
    wire [7:0] rem4 = (step4 >= {1'b0, B}) ? (step4 - B) : step4[7:0];
    
    wire [8:0] step5 = {rem4, A[10]};
    wire [7:0] rem5 = (step5 >= {1'b0, B}) ? (step5 - B) : step5[7:0];
    
    wire [8:0] step6 = {rem5, A[9]};
    wire [7:0] rem6 = (step6 >= {1'b0, B}) ? (step6 - B) : step6[7:0];
    
    wire [8:0] step7 = {rem6, A[8]};
    wire [7:0] rem7 = (step7 >= {1'b0, B}) ? (step7 - B) : step7[7:0];
    
    wire [8:0] step8 = {rem7, A[7]};
    wire [7:0] rem8 = (step8 >= {1'b0, B}) ? (step8 - B) : step8[7:0];
    
    wire [8:0] step9 = {rem8, A[6]};
    wire [7:0] rem9 = (step9 >= {1'b0, B}) ? (step9 - B) : step9[7:0];
    
    wire [8:0] step10 = {rem9, A[5]};
    wire [7:0] rem10 = (step10 >= {1'b0, B}) ? (step10 - B) : step10[7:0];
    
    wire [8:0] step11 = {rem10, A[4]};
    wire [7:0] rem11 = (step11 >= {1'b0, B}) ? (step11 - B) : step11[7:0];
    
    wire [8:0] step12 = {rem11, A[3]};
    wire [7:0] rem12 = (step12 >= {1'b0, B}) ? (step12 - B) : step12[7:0];
    
    wire [8:0] step13 = {rem12, A[2]};
    wire [7:0] rem13 = (step13 >= {1'b0, B}) ? (step13 - B) : step13[7:0];
    
    wire [8:0] step14 = {rem13, A[1]};
    wire [7:0] rem14 = (step14 >= {1'b0, B}) ? (step14 - B) : step14[7:0];
    
    wire [8:0] step15 = {rem14, A[0]};
    wire [7:0] rem15 = (step15 >= {1'b0, B}) ? (step15 - B) : step15[7:0];

    assign result = {
        (step0 >= {1'b0, B}),
        (step1 >= {1'b0, B}),
        (step2 >= {1'b0, B}),
        (step3 >= {1'b0, B}),
        (step4 >= {1'b0, B}),
        (step5 >= {1'b0, B}),
        (step6 >= {1'b0, B}),
        (step7 >= {1'b0, B}),
        (step8 >= {1'b0, B}),
        (step9 >= {1'b0, B}),
        (step10 >= {1'b0, B}),
        (step11 >= {1'b0, B}),
        (step12 >= {1'b0, B}),
        (step13 >= {1'b0, B}),
        (step14 >= {1'b0, B}),
        (step15 >= {1'b0, B})
    };
    
    assign odd = rem15;

endmodule