module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and needs correction
    wire correction_needed;
    assign correction_needed = (binary_sum > 9) ? 1'b1 : 1'b0;

    // Apply BCD correction if needed
    wire [3:0] corrected_sum;
    assign corrected_sum = (correction_needed) ? (binary_sum + 6) : binary_sum;

    // Ensure the output is only 4 bits
    assign Sum = corrected_sum[3:0];

    // Generate carry-out if the result exceeds 9
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

endmodule