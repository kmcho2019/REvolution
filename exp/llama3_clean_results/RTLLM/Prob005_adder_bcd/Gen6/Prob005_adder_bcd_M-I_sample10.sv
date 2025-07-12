module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_with_carry = A + B + Cin;

    // Calculate the actual sum considering BCD correction
    assign Sum = (sum_with_carry > 9) ? (sum_with_carry + 6) : sum_with_carry;

    // Generate Cout based on the conditions that exceed BCD range or have an incoming carry
    assign Cout = (sum_with_carry > 9) || (sum_with_carry[4] == 1'b1);

endmodule