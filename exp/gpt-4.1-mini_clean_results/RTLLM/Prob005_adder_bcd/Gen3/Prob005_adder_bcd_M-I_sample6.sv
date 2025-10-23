module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;      // Sum including carry bit
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Perform binary addition
    assign binary_sum = A + B + Cin;

    // Detect if correction needed:
    // Correction needed if sum > 9
    // sum > 9 if MSB (bit 4) is set, or (bit 3 and (bit 2 or bit 1)) is set
    assign correction_needed = binary_sum[4] | (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Add 6 (0110) if correction needed
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Output sum is lower 4 bits after correction
    assign Sum = corrected_sum[3:0];

    // Carry out is MSB after correction
    assign Cout = corrected_sum[4];

endmodule