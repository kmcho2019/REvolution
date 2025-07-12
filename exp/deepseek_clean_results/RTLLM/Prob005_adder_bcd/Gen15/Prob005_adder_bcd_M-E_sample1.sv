module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Prediction logic: cases where sum will definitely be >9
    wire A_ge_5 = A[3] & (A[2] | A[1]);  // A >= 5
    wire B_ge_5 = B[3] & (B[2] | B[1]);  // B >= 5
    wire sum_will_overflow = (A_ge_5 & B_ge_5) |  // 5+5=10
                           (A[3] & B[3]) |      // 8+8=16
                           ((A == 4'd9) & (B != 4'd0)) |  // 9 + any
                           ((B == 4'd9) & (A != 4'd0));   // any + 9

    // Compute both possible sums in parallel
    wire [3:0] sum_no_corr = A + B + Cin;
    wire [3:0] sum_with_corr = sum_no_corr + 4'd6;

    // Final selection
    wire need_correction = sum_will_overflow | (sum_no_corr > 9);
    assign Sum = need_correction ? sum_with_corr : sum_no_corr;
    assign Cout = need_correction;

endmodule