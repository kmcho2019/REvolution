module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_with_carry = A + B + Cin;

    // Calculate the sum without considering BCD correction
    wire [3:0] temp_sum = sum_with_carry[3:0];

    // Apply BCD correction if the sum exceeds 9
    wire [3:0] corrected_sum = (sum_with_carry > 4'd9)? (temp_sum + 4'd6) : temp_sum;

    // Generate Cout if the sum exceeds 9 or if there's a carry from the addition
    assign Cout = (sum_with_carry > 4'd9) || sum_with_carry[4];

    // Assign the final Sum
    assign Sum = corrected_sum;

endmodule