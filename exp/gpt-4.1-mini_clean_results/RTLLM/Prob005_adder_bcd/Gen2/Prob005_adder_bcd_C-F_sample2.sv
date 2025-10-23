module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       carry_4bit;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Binary addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // carry from the lower 4 bits addition
    assign carry_4bit = raw_sum[4];

    // Simplified BCD correction condition:
    // correction needed if carry out from 4-bit sum is set
    // OR if sum is greater than 9, which can be checked by:
    // sum[3] & (sum[2] | sum[1]) (covers 1010 to 1111)
    assign correction_needed = carry_4bit | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // If correction is needed, add 6 (0110) to raw_sum
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output the corrected 4-bit BCD sum and carry out
    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule