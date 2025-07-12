module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Perform binary addition of A, B, and Cin
    wire [4:0] raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9 (decimal)
    // 9 decimal = 4'b1001, so check if raw_sum >= 10
    wire correction_needed = (raw_sum > 5'd9);

    // If correction needed, subtract 10 (decimal) = 5'b01010 from raw_sum
    // Subtraction: corrected_sum = raw_sum - 10
    // Carry-out is 1 if correction is applied (indicates decimal carry to next digit)
    wire [4:0] corrected = raw_sum - 5'd10;

    // Assign corrected sum bits or raw sum bits based on correction_needed
    // Only lower 4 bits are output as BCD digit sum
    assign Sum  = correction_needed ? corrected[3:0] : raw_sum[3:0];
    assign Cout = correction_needed;

endmodule