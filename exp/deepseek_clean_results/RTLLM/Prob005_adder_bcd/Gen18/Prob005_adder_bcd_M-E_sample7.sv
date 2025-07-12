module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Early overflow prediction
    // Predict overflow if either:
    // 1. A + B >= 10 (regardless of carry)
    // 2. A + B == 9 and carry-in is 1
    wire [4:0] sum_pred = A + B;
    wire will_overflow = (sum_pred > 9) || (sum_pred == 9 && Cin);

    // Compute both possible sums in parallel
    wire [3:0] raw_sum = A + B + Cin;
    wire [3:0] corrected_sum = raw_sum + 6;

    // Select appropriate result
    assign Sum = will_overflow ? corrected_sum : raw_sum;
    assign Cout = will_overflow;

endmodule