module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_with_carry = A + B + Cin;

    // Assign Sum directly and generate Cout based on the sum exceeding 9 or having a carry
    assign Sum = sum_with_carry[3:0] + (sum_with_carry > 9 ? 4'd6 : 4'd0);
    assign Cout = sum_with_carry[4];

endmodule