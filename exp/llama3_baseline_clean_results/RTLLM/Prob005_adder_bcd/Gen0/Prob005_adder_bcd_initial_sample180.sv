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
    wire exceeds_9;
    assign exceeds_9 = (binary_sum > 4'd9) ? 1'b1 : 1'b0;

    // BCD correction: add 6 (binary 0110) to the sum if it exceeds 9
    wire [4:0] corrected_sum;
    assign corrected_sum = exceeds_9 ? binary_sum + 4'd6 : binary_sum;

    // Assign corrected sum to Sum output, discarding any carry
    assign Sum = corrected_sum[3:0];

    // Generate carry-out (Cout) signal if the result exceeds 9
    assign Cout = exceeds_9 ? 1'b1 : (binary_sum[4] == 1'b1) ? 1'b1 : 1'b0;

endmodule