module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_with_carry = A + B + Cin;

    // Apply BCD correction and generate carry in a single step
    assign Sum = (sum_with_carry > 9) ? (sum_with_carry + 6)[3:0] : sum_with_carry[3:0];
    assign Cout = (sum_with_carry > 9);

endmodule