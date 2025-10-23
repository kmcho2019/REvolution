module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Perform initial 5-bit binary addition of A, B, and Cin
    wire [4:0] raw_sum = A + B + Cin;

    // Detect if BCD correction is needed (raw_sum > 9)
    wire correction_needed = (raw_sum > 5'd9);

    // If correction needed, add 6 (binary 00110) to raw_sum for BCD correction
    wire [4:0] corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Sum output is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry out is MSB of corrected sum
    assign Cout = corrected_sum[4];

endmodule