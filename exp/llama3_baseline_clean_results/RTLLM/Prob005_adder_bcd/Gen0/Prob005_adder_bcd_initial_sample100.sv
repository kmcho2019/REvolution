module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] sum_with_carry; // Wire to hold the result of binary addition of A, B, and Cin

    // Perform binary addition
    assign sum_with_carry = A + B + Cin;

    // Generate the BCD sum and Cout
    assign Sum = (sum_with_carry > 9)? (sum_with_carry + 6) : sum_with_carry;
    assign Cout = (sum_with_carry > 9)? 1'b1 : 1'b0;

    // Correct the Sum output to be within 4 bits since the addition result exceeds 9
    // This is not necessary as the previous line already handles this, but for clarity:
    // assign Sum = Sum[3:0];

endmodule