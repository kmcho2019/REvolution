module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;
    wire [4:0] corrected_sum;
    wire       correction_needed;

    // Binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // Determine if correction is needed: sum > 9 (4'b1001) or carry out is set
    assign correction_needed = (binary_sum > 5'd9);

    // If correction needed, add 6 (0110) to binary_sum
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Final sum is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry out is the 5th bit of corrected sum
    assign Cout = corrected_sum[4];

endmodule