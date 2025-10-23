module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] binary_sum; // 5 bits to hold sum with carry out
    wire       carry_out_bit3; 
    wire       bcd_invalid;
    wire [4:0] corrected_sum;

    // Perform binary addition
    assign binary_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Carry out from bit 3 (4th bit)
    assign carry_out_bit3 = binary_sum[4];

    // Condition to detect invalid BCD sum:
    // sum > 9 can be detected as (bit3 AND (bit2 OR bit1)) OR carry_out_bit3
    assign bcd_invalid = carry_out_bit3 | (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Add 6 (0110) if invalid to correct the BCD sum
    assign corrected_sum = bcd_invalid ? (binary_sum + 5'd6) : binary_sum;

    // Final sum and carry out
    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule