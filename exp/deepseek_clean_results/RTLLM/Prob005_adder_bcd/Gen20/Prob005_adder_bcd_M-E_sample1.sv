module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Pre-calculate both possible sums
    wire [3:0] sum_uncorrected = A + B + Cin;
    wire [3:0] sum_corrected = sum_uncorrected + 4'd6;
    
    // Overflow prediction using bit patterns
    wire will_overflow = (A[3] & B[3]) |          // Both >= 8
                       ((A[3] | B[3]) &          // One >= 8 and
                       (A[2] | B[2] | Cin));     // other >= 2 or carry
    
    // Result selection
    assign Sum = will_overflow ? sum_corrected : sum_uncorrected;
    
    // Carry generation
    assign Cout = will_overflow | (sum_uncorrected > 4'd9);

endmodule