module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] bin_sum;
    wire [4:0] corrected_sum;
    wire       correction_needed;

    // Perform binary addition of A, B and Cin
    assign bin_sum = A + B + Cin;

    // Correction needed if sum > 9 or carry from addition
    assign correction_needed = (bin_sum > 5'd9);

    // Add 6 if correction is needed to get valid BCD sum
    assign corrected_sum = correction_needed ? (bin_sum + 5'd6) : bin_sum;

    // Assign the 4-bit BCD sum and carry out
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule