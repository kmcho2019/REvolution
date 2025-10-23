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

    // Check if the sum exceeds 9 and apply BCD correction if necessary
    assign Sum = (binary_sum > 9) ? binary_sum + 6 : binary_sum[3:0];

    // Generate carry-out signal
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

endmodule