module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;     // 5 bits to hold sum + carry
    wire [4:0] corrected_sum;
    wire       correction_needed;

    // Binary addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Correction is needed if sum > 9 (binary 1001)
    assign correction_needed = (raw_sum > 9);

    // If correction needed, add 6 (binary 0110)
    assign corrected_sum = correction_needed ? (raw_sum + 6) : raw_sum;

    // Output sum is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry out is MSB of corrected sum (bit 4)
    assign Cout = corrected_sum[4];

endmodule