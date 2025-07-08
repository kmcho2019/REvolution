module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;    // 5 bits to hold sum + carry
    wire [4:0] corrected_sum;
    wire       correction_needed;

    // Binary addition of A, B and Cin
    assign raw_sum = A + B + Cin;

    // Correction needed if sum > 9 or carry out from addition
    assign correction_needed = (raw_sum > 9);

    // Add 6 (0110) if correction is needed
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output corrected 4-bit sum and carry out
    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule