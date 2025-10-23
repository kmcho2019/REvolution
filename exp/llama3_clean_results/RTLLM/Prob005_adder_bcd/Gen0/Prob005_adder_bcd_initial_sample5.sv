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

    // Check if the sum exceeds 9 (1001 in binary) and generate carry-out accordingly
    assign Cout = (binary_sum > 4'd9) ? 1'b1 : 1'b0;

    // If the sum exceeds 9, add correction of 6 (0110 in binary) to ensure BCD validity
    assign Sum = (binary_sum > 4'd9) ? (binary_sum + 4'd6)[3:0] : binary_sum[3:0];

endmodule