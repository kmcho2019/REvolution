module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Prediction logic: Will the sum need correction?
    // This looks at the inputs rather than waiting for the sum
    wire will_overflow = (A > 4'd9) | (B > 4'd9) |  // Either input invalid (defensive)
                        ((A == 4'd9) & (B > 4'd0)) |  // 9 + any positive number
                        ((A > 4'd5) & (B > 4'd4)) |  // Sum of halves will exceed 9
                        ((A + B + Cin) > 4'd9);      // Also include traditional check for robustness

    // Compute both possible sums in parallel
    wire [3:0] sum_no_correction = A + B + Cin;
    wire [3:0] sum_with_correction = sum_no_correction + 4'd6;

    // Select appropriate result based on prediction
    assign Sum = will_overflow ? sum_with_correction : sum_no_correction;
    assign Cout = will_overflow;

endmodule