module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // First stage: Perform binary addition and generate carry if sum exceeds 9
    wire [3:0] binary_sum = A + B + Cin;
    wire carry_generated = (binary_sum > 4'd9);

    // Second stage: Apply BCD correction if carry is generated
    assign Sum = carry_generated? (binary_sum + 4'd6) : binary_sum;
    assign Cout = carry_generated;

endmodule