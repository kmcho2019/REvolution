module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Prediction logic: Will A+B+Cin require BCD correction?
    // Conditions where sum will be >9:
    // 1. A + B >= 10 (regardless of Cin)
    // 2. A + B == 9 and Cin == 1
    wire a_ge_5 = A[3] & (A[2] | A[1]);  // A >= 5
    wire b_ge_5 = B[3] & (B[2] | B[1]);  // B >= 5
    wire sum_ge_10 = (a_ge_5 & b_ge_5) |  // Both >=5
                    ((A[3] | B[3]) & (A[2] & B[2])) |  // Either >=8 and both >=4
                    (A == 4'd9 && B != 4'd0) |  // A=9 and B>0
                    (B == 4'd9 && A != 4'd0);    // B=9 and A>0
    
    wire sum_eq_9 = (A + B == 4'd9);
    wire need_correction = sum_ge_10 | (sum_eq_9 & Cin);
    assign Cout = need_correction;

    // Parallel computation paths
    wire [3:0] sum_uncorrected = A + B + Cin;
    wire [3:0] sum_corrected = A + B + Cin + 4'd6;

    // Select appropriate sum based on prediction
    assign Sum = need_correction ? sum_corrected : sum_uncorrected;

endmodule