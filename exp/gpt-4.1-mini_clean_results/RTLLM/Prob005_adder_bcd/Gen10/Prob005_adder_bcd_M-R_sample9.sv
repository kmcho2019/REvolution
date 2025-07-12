module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Perform binary addition of A, B and Cin to produce a 5-bit sum
    wire [4:0] raw_sum = A + B + Cin;

    // Detect if correction is needed (sum > 9)
    // Correction needed if raw_sum > 9:
    // raw_sum[4] == 1 means sum >= 16, or 
    // raw_sum[3] & (raw_sum[2] | raw_sum[1]) covers 10..15
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // If correction needed, add 6 (binary 00110) to raw_sum
    wire [4:0] corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output sum is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry out is the MSB of corrected sum
    assign Cout = corrected_sum[4];

endmodule