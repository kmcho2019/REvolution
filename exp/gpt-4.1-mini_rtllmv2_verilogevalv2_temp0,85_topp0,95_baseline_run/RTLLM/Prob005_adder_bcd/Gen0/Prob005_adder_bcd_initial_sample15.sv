module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Perform raw binary addition of A, B and Cin
    assign raw_sum = A + B + Cin;

    // Determine if correction is needed: sum > 9 or carry from bit 3
    assign correction_needed = (raw_sum > 9);

    // Add 6 (0110) if correction is needed
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output the lower 4 bits as BCD sum and carry as Cout
    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule