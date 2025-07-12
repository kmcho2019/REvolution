module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = {A[3:0]} + {B[3:0]} + Cin;

    // Check if the sum exceeds 9 (binary 1001) and apply correction
    wire [4:0] corrected_sum;
    wire carry_out;

    // If sum exceeds 9, add 6 (binary 0110) for BCD correction
    assign corrected_sum = (binary_sum > 9) ? (binary_sum + 6) : binary_sum;
    assign Cout = (binary_sum > 9) || ((binary_sum + 6) > 9); // Corrected condition to ensure Cout is set when result exceeds 9 after adding correction

    // Assign the final sum, taking only the lower 4 bits
    assign Sum = corrected_sum[3:0];

endmodule