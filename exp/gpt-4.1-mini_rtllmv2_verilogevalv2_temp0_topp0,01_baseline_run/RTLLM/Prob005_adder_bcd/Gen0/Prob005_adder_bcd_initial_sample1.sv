module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;       // 5 bits to hold sum + carry
    wire [4:0] corrected_sum;
    wire       correction_needed;

    // Binary addition of inputs and carry-in
    assign raw_sum = A + B + Cin;

    // Determine if correction is needed:
    // Correction needed if raw_sum > 9 (decimal 9 = 4'b1001)
    // or if there is a carry out from bit 3 (raw_sum[4] == 1)
    assign correction_needed = (raw_sum > 5'd9);

    // Add 6 (0110) if correction is needed
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output sum is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry out is the 5th bit of corrected sum
    assign Cout = corrected_sum[4];

endmodule