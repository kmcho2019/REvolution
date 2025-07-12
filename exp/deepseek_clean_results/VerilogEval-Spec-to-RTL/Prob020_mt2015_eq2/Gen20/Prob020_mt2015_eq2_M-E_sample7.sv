module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Thermometer code decoders
    wire A_is_00 = ~A[1] & ~A[0];
    wire A_is_01 = ~A[1] &  A[0];
    wire A_is_10 =  A[1] & ~A[0];
    wire A_is_11 =  A[1] &  A[0];
    
    wire B_is_00 = ~B[1] & ~B[0];
    wire B_is_01 = ~B[1] &  B[0];
    wire B_is_10 =  B[1] & ~B[0];
    wire B_is_11 =  B[1] &  B[0];
    
    // Equality check for each possible value
    wire eq_00 = A_is_00 & B_is_00;
    wire eq_01 = A_is_01 & B_is_01;
    wire eq_10 = A_is_10 & B_is_10;
    wire eq_11 = A_is_11 & B_is_11;
    
    // Final equality output
    assign z = eq_00 | eq_01 | eq_10 | eq_11;
endmodule