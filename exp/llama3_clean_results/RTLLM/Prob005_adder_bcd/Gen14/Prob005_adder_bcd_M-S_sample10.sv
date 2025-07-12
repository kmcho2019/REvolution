module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;

    // Generate carry-out
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

    // BCD correction: add 6 if sum exceeds 9
    assign Sum = (binary_sum > 9) ? (binary_sum + 6)[3:0] : binary_sum[3:0];

endmodule