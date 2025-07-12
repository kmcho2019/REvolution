module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;   // Sum of A, B and Cin with carry out bit
    wire       overflow;  // Overflow indicates sum > 9
    wire [4:0] corrected_sum;

    // Step 1: Binary addition of inputs
    assign raw_sum = A + B + Cin;

    // Step 2: Overflow detection (sum > 9)
    // Condition: raw_sum > 9 is detected by the logic below
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Apply BCD correction conditionally
    // When overflow is true, add 6 (binary 0110) to raw_sum
    // This addition won't generate carry beyond 5 bits as max raw_sum=19 + 6 = 25 < 32
    assign corrected_sum = overflow ? (raw_sum + 5'd6) : raw_sum;

    // Final outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule