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

    // Check if the sum exceeds 9 (binary 1001)
    // If it does, apply a correction by adding 6 (binary 0110) to the result
    reg [3:0] corrected_sum;
    assign corrected_sum = (binary_sum > 9) ? binary_sum + 6 : binary_sum;

    // Assign the corrected sum to the output Sum, ensuring it's a valid BCD digit
    assign Sum = corrected_sum[3:0];

    // Generate a carry-out (Cout) if the result after correction exceeds 9
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

endmodule