module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute 4-bit sum with carry chain
    wire [3:0] sum_low;
    wire carry_low;
    wire [3:0] sum_high;
    wire carry_high;

    // Low nibble addition (A+B)
    assign {carry_low, sum_low} = A + B;

    // Final addition with Cin
    assign {carry_high, sum_high} = sum_low + Cin;

    // Correction needed if:
    // 1. Original sum > 9 (1001) -> sum_high[3] & (sum_high[2] | sum_high[1])
    // 2. Or carry from any addition (carry_low | carry_high)
    wire correction_needed = (sum_high[3] & (sum_high[2] | sum_high[1])) | 
                            carry_low | carry_high;

    // Apply correction and generate final sum
    assign Sum = sum_high + (correction_needed ? 4'd6 : 4'd0);
    assign Cout = correction_needed;

endmodule