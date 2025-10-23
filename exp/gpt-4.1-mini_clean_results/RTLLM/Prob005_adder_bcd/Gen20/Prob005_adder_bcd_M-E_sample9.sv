module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] binary_sum;
    wire       bcd_overflow;
    wire [3:0] corrected_sum;

    // Step 1: Binary addition of inputs + carry-in
    assign binary_sum = A + B + Cin;

    // Step 2: BCD overflow detection
    // Condition for sum > 9 in BCD:
    // overflow if (binary_sum[4] == 1) OR (binary_sum[3] & binary_sum[2]) == 1
    assign bcd_overflow = binary_sum[4] | (binary_sum[3] & binary_sum[2]);

    // Step 3: Add correction (6) if overflow detected
    assign corrected_sum = bcd_overflow ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];

    // Step 4: Outputs
    assign Sum  = corrected_sum;
    assign Cout = bcd_overflow;

endmodule