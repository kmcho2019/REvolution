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

    // Check if the sum exceeds 9 and apply correction if necessary
    wire [3:0] corrected_sum;
    assign corrected_sum = (binary_sum > 9)? binary_sum + 6 : binary_sum[3:0];

    // Assign the corrected sum to the output Sum
    assign Sum = corrected_sum;

    // Generate carry-out if the result of the addition exceeds 9
    assign Cout = (binary_sum > 9) || (binary_sum + 6 > 15);

endmodule