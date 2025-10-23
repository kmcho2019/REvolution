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

    // Check if the sum exceeds 9 and apply BCD correction
    wire bcd_correction_needed = (sum_with_carry > 4'd9) || (sum_with_carry[4] == 1'b1);
    wire [3:0] corrected_sum = bcd_correction_needed? (temp_sum + 4'd6) : temp_sum;

    // Assign Sum and generate Cout
    assign Sum = corrected_sum;
    assign Cout = bcd_correction_needed;

endmodule