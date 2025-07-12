module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Initial binary addition of A, B and Cin
    assign binary_sum = A + B + Cin;

    // Determine if correction is needed: sum > 9 or carry out from 4-bit sum
    assign correction_needed = (binary_sum[4] == 1'b1) || (binary_sum[3:0] > 4'd9);

    // If correction needed, add 6 (0110) to binary_sum to produce corrected_sum
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Sum output is lower 4 bits of corrected_sum
    assign Sum = corrected_sum[3:0];

    // Cout is the carry out from corrected sum (bit 4)
    assign Cout = corrected_sum[4];

endmodule