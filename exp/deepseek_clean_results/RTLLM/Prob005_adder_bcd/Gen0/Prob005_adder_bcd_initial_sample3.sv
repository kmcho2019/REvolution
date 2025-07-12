module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] binary_sum;
    wire carry_out;
    wire correction_needed;
    wire [3:0] corrected_sum;
    wire final_carry;

    // First perform binary addition
    assign {carry_out, binary_sum} = A + B + Cin;

    // Determine if correction is needed (sum > 9 or carry out occurred)
    assign correction_needed = (binary_sum > 4'd9) || carry_out;

    // Apply correction if needed (add 6)
    assign corrected_sum = correction_needed ? (binary_sum + 4'd6) : binary_sum;

    // Final sum is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Final carry is either the original carry_out or if correction caused a carry
    assign final_carry = correction_needed ? 1'b1 : carry_out;
    assign Cout = final_carry;

endmodule