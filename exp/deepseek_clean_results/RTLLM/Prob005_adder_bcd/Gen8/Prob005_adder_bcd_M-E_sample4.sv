module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Early prediction of correction need (without waiting for sum)
    // Conditions that would require correction:
    // 1. If A + B + Cin >= 10 (using carry lookahead principles)
    // 2. If A + B + Cin would generate a carry in binary addition
    wire [3:0] carry_propagate = A ^ B;
    wire [3:0] carry_generate = A & B;
    
    // Simplified carry lookahead for correction prediction
    wire c1 = carry_generate[0] | (carry_propagate[0] & Cin);
    wire c2 = carry_generate[1] | (carry_propagate[1] & c1);
    wire c3 = carry_generate[2] | (carry_propagate[2] & c2);
    wire correction_predicted = carry_generate[3] | (carry_propagate[3] & c3) |
                               (A[3] & B[3]) |  // Both MSBs set (sum >= 12)
                               ((A[3] | B[3]) & (A[2] & B[2]));  // Sum >= 10 cases

    // Compute both possible sums in parallel
    wire [3:0] sum_uncorrected = A + B + Cin;
    wire [3:0] sum_corrected = sum_uncorrected + 4'b0110;
    
    // Select correct sum based on prediction
    assign Sum = correction_predicted ? sum_corrected : sum_uncorrected;
    assign Cout = correction_predicted;

endmodule