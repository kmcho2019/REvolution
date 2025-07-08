module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] binary_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Perform binary addition with carry in
    assign binary_sum = A + B + Cin;

    // Correction needed if sum > 9 or if carry out of bit3 is set
    assign correction_needed = (binary_sum > 9);

    // Add 6 for BCD correction if needed
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Output sum is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry out is the 5th bit of corrected sum
    assign Cout = corrected_sum[4];

endmodule