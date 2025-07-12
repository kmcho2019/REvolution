module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Zero-division check
    wire zero_divisor = (B == 8'b0);
    
    // Remainder wires for each stage (9 bits: 8 remainder + 1 comparison)
    wire [8:0] rem15, rem14, rem13, rem12, rem11, rem10, rem9, rem8;
    wire [8:0] rem7, rem6, rem5, rem4, rem3, rem2, rem1, rem0;
    
    // Stage 15 (MSB)
    assign rem15 = {1'b0, A[15]};
    assign result[15] = zero_divisor ? 1'b0 : (rem15 >= {1'b0, B});
    
    // Subsequent stages
    assign rem14 = result[15] ? (rem15 - {1'b0, B}) : rem15;
    assign result[14] = zero_divisor ? 1'b0 : ({rem14[7:0], A[14]} >= {1'b0, B});
    
    assign rem13 = result[14] ? ({rem14[7:0], A[14]} - {1'b0, B}) : {rem14[7:0], A[14]};
    assign result[13] = zero_divisor ? 1'b0 : ({rem13[7:0], A[13]} >= {1'b0, B});
    
    assign rem12 = result[13] ? ({rem13[7:0], A[13]} - {1'b0, B}) : {rem13[7:0], A[13]};
    assign result[12] = zero_divisor ? 1'b0 : ({rem12[7:0], A[12]} >= {1'b0, B});
    
    assign rem11 = result[12] ? ({rem12[7:0], A[12]} - {1'b0, B}) : {rem12[7:0], A[12]};
    assign result[11] = zero_divisor ? 1'b0 : ({rem11[7:0], A[11]} >= {1'b0, B});
    
    assign rem10 = result[11] ? ({rem11[7:0], A[11]} - {1'b0, B}) : {rem11[7:0], A[11]};
    assign result[10] = zero_divisor ? 1'b0 : ({rem10[7:0], A[10]} >= {1'b0, B});
    
    assign rem9 = result[10] ? ({rem10[7:0], A[10]} - {1'b0, B}) : {rem10[7:0], A[10]};
    assign result[9] = zero_divisor ? 1'b0 : ({rem9[7:0], A[9]} >= {1'b0, B});
    
    assign rem8 = result[9] ? ({rem9[7:0], A[9]} - {1'b0, B}) : {rem9[7:0], A[9]};
    assign result[8] = zero_divisor ? 1'b0 : ({rem8[7:0], A[8]} >= {1'b0, B});
    
    assign rem7 = result[8] ? ({rem8[7:0], A[8]} - {1'b0, B}) : {rem8[7:0], A[8]};
    assign result[7] = zero_divisor ? 1'b0 : ({rem7[7:0], A[7]} >= {1'b0, B});
    
    assign rem6 = result[7] ? ({rem7[7:0], A[7]} - {1'b0, B}) : {rem7[7:0], A[7]};
    assign result[6] = zero_divisor ? 1'b0 : ({rem6[7:0], A[6]} >= {1'b0, B});
    
    assign rem5 = result[6] ? ({rem6[7:0], A[6]} - {1'b0, B}) : {rem6[7:0], A[6]};
    assign result[5] = zero_divisor ? 1'b0 : ({rem5[7:0], A[5]} >= {1'b0, B});
    
    assign rem4 = result[5] ? ({rem5[7:0], A[5]} - {1'b0, B}) : {rem5[7:0], A[5]};
    assign result[4] = zero_divisor ? 1'b0 : ({rem4[7:0], A[4]} >= {1'b0, B});
    
    assign rem3 = result[4] ? ({rem4[7:0], A[4]} - {1'b0, B}) : {rem4[7:0], A[4]};
    assign result[3] = zero_divisor ? 1'b0 : ({rem3[7:0], A[3]} >= {1'b0, B});
    
    assign rem2 = result[3] ? ({rem3[7:0], A[3]} - {1'b0, B}) : {rem3[7:0], A[3]};
    assign result[2] = zero_divisor ? 1'b0 : ({rem2[7:0], A[2]} >= {1'b0, B});
    
    assign rem1 = result[2] ? ({rem2[7:0], A[2]} - {1'b0, B}) : {rem2[7:0], A[2]};
    assign result[1] = zero_divisor ? 1'b0 : ({rem1[7:0], A[1]} >= {1'b0, B});
    
    assign rem0 = result[1] ? ({rem1[7:0], A[1]} - {1'b0, B}) : {rem1[7:0], A[1]};
    assign result[0] = zero_divisor ? 1'b0 : ({rem0[7:0], A[0]} >= {1'b0, B});
    
    // Final remainder output
    assign odd = zero_divisor ? 8'b0 : 
                (result[0] ? ({rem0[7:0], A[0]} - {1'b0, B}) : {rem0[7:0], A[0]});

endmodule