module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_with_carry = A + B + Cin;

    // Generate Cout based on the sum exceeding 9 or having a carry
    assign Cout = sum_with_carry[4] || (sum_with_carry[3:0] > 4'd9);

    // Assign Sum directly with BCD correction
    assign Sum = (sum_with_carry[3:0] > 4'd9)? (sum_with_carry[3:0] + 4'd6) : sum_with_carry[3:0];

endmodule