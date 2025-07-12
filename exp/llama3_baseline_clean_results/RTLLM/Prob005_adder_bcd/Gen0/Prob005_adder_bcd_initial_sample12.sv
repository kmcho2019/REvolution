module adder_bcd(
    A, 
    B, 
    Cin, 
    Sum, 
    Cout
);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] Sum;
    output Cout;

    wire [3:0] binary_sum;
    wire [3:0] corrected_sum;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // Apply BCD correction if the sum exceeds 9
    assign corrected_sum = (binary_sum > 9) ? binary_sum + 6 : binary_sum;

    // Assign the corrected sum to the output Sum
    assign Sum = corrected_sum;

    // Generate a carry-out (Cout) signal if the result exceeds 9
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

endmodule