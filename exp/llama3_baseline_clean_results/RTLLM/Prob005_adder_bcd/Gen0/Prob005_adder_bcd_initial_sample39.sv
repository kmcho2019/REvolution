module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition
    wire [4:0] binary_sum = A + B + Cin;

    // Apply BCD correction if sum exceeds 9
    assign Sum = (binary_sum > 9) ? (binary_sum + 6) [3:0] : binary_sum [3:0];

    // Generate carry-out
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

endmodule