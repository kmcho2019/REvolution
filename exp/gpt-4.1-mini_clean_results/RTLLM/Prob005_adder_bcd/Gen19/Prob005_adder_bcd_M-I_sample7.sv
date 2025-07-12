module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: 4-bit binary addition with 5-bit result to capture carry-out
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Efficient correction detection (raw_sum > 9)
    // Correction needed if MSB set or bits 3 and (2 or 1) set
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Conditional addition of 6 (0110) for BCD correction when needed
    // Add 6 only if correction_needed else 0
    wire [4:0] corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Output assignments
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule